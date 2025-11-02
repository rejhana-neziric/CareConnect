using CareConnect.Models.WorkshopML;
using Microsoft.ML.Data;
using Microsoft.ML;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CareConnect.Services.Database;
using Microsoft.ML.Trainers.FastTree;
using CareConnect.Models.Requests;
using Microsoft.Extensions.Logging;

namespace CareConnect.Services.WorkshopML
{
    public class WorkshopMLService : IWorkshopMLService
    {
        private readonly MLContext _mlContext;

        private readonly string _modelPath;
        
        private ITransformer? _model;

        private readonly Dictionary<string, float> _workshopTypeMapping;

        ILogger<WorkshopMLService> _logger;

        public WorkshopMLService(ILogger<WorkshopMLService> logger, string modelPath = "workshop_model.zip")
        {
            _mlContext = new MLContext(seed: 0);
            _modelPath = modelPath;
            _logger = logger;   

            _workshopTypeMapping = new Dictionary<string, float>();

            if (File.Exists(_modelPath))
            {
                LoadModel();
            }
        }

        public void TrainModel(List<Workshop> historicalWorkshops)
        {
            if (historicalWorkshops == null || historicalWorkshops.Count < 10) 
            {
                throw new InvalidOperationException("Need at least 10 completed workshops to train the model.");
            }

            BuildWorkshopTypeMapping(historicalWorkshops);

            var trainingData = historicalWorkshops
                .Where(w => w.Participants.HasValue && w.Participants.Value > 0)
                .Select(w => TransformToWorkshopData(w))
                .ToList();

            var dataView = _mlContext.Data.LoadFromEnumerable(trainingData);

            // 80% training, 20% testing
            var trainTestSplit = _mlContext.Data.TrainTestSplit(dataView, testFraction: 0.2);

            var pipeline = _mlContext.Transforms.Concatenate("Features",
                    nameof(WorkshopData.Price),
                    nameof(WorkshopData.MaxParticipants),
                    nameof(WorkshopData.DayOfWeek),
                    nameof(WorkshopData.Month),
                    nameof(WorkshopData.Hour),
                    nameof(WorkshopData.IsWeekend),
                    nameof(WorkshopData.DaysUntilWorkshop),
                    nameof(WorkshopData.WorkshopTypeEncoded),
                    nameof(WorkshopData.PriceToMaxRatio))
                .Append(_mlContext.Regression.Trainers.FastTree(new FastTreeRegressionTrainer.Options
                {
                    NumberOfLeaves = 20,
                    MinimumExampleCountPerLeaf = 10,
                    NumberOfTrees = 100,
                    LearningRate = 0.2,
                    Shrinkage = 0.3,
                    LabelColumnName = "Label",
                    FeatureColumnName = "Features"
                }));

            _model = pipeline.Fit(trainTestSplit.TrainSet);

            var predictions = _model.Transform(trainTestSplit.TestSet);
            var metrics = _mlContext.Regression.Evaluate(predictions, labelColumnName: "Label");

            _logger.LogInformation($"Model trained successfully!");
            _logger.LogInformation($"R-Squared: {metrics.RSquared:0.##}");
            _logger.LogInformation($"Root Mean Squared Error: {metrics.RootMeanSquaredError:0.##}");
            _logger.LogInformation($"Mean Absolute Error: {metrics.MeanAbsoluteError:0.##}");

            SaveModel(dataView.Schema);
        }

        public WorkshopPrediction PredictParticipants(WorkshopInsertRequest workshop)
        {
            if (_model == null)
            {
                throw new InvalidOperationException("Model is not trained or loaded. Train the model first.");
            }

            var input = TransformToWorkshopData(workshop);
            var predictionEngine = _mlContext.Model.CreatePredictionEngine<WorkshopData, WorkshopPrediction>(_model);
            var prediction = predictionEngine.Predict(input);

            prediction.PredictedParticipants = Math.Max(0, prediction.PredictedParticipants);
            if (workshop.MaxParticipants.HasValue)
            {
                prediction.PredictedParticipants = Math.Min(prediction.PredictedParticipants, workshop.MaxParticipants.Value);
            }

            return prediction;
        }

        public RegressionMetrics? EvaluateModel(List<Workshop> testWorkshops)
        {
            if (_model == null) return null;

            var testData = testWorkshops
                .Where(w => w.Participants.HasValue && w.Participants.Value > 0)
                .Select(w => TransformToWorkshopData(w))
                .ToList();

            var dataView = _mlContext.Data.LoadFromEnumerable(testData);
            var predictions = _model.Transform(dataView);

            return _mlContext.Regression.Evaluate(predictions, labelColumnName: "Label");
        }

        private void SaveModel(DataViewSchema schema)
        {
            _mlContext.Model.Save(_model, schema, _modelPath);
            Console.WriteLine($"Model saved to {_modelPath}");
        }

        private void LoadModel()
        {
            _model = _mlContext.Model.Load(_modelPath, out var modelSchema);
            Console.WriteLine($"Model loaded from {_modelPath}");
        }

        private void BuildWorkshopTypeMapping(List<Workshop> workshops)
        {
            var uniqueTypes = workshops
                .Select(w => w.WorkshopType)
                .Distinct()
                .OrderBy(t => t)
                .ToList();

            _workshopTypeMapping.Clear();
            for (int i = 0; i < uniqueTypes.Count; i++)
            {
                _workshopTypeMapping[uniqueTypes[i]] = i;
            }
        }

        private WorkshopData TransformToWorkshopData<T>(T workshop) where T : class
        {
            dynamic w = workshop;

            decimal priceValue = (decimal?)w.Price ?? 0m; 
            int maxParticipantsValue = (int?)w.MaxParticipants ?? 30;

            float price = (float)priceValue;
            float maxParticipants = (float)maxParticipantsValue;

            float typeEncoded = _workshopTypeMapping.ContainsKey((string)w.WorkshopType)
                ? _workshopTypeMapping[(string)w.WorkshopType]
                : 0;

            DateTime date = w.Date;

            DateTime modifiedDate = (w.GetType().GetProperty("ModifiedDate") != null)
                ? (DateTime)w.ModifiedDate
                : DateTime.UtcNow;

            float daysUntilWorkshop = (float)(date - modifiedDate).TotalDays;
            float priceToMaxRatio = maxParticipants > 0 ? price / maxParticipants : 0;

            float participants = 0;
            var participantsProp = w.GetType().GetProperty("Participants");
            if (participantsProp != null && participantsProp.GetValue(w) != null)
                participants = Convert.ToSingle(participantsProp.GetValue(w));

            return new WorkshopData
            {
                Price = price,
                MaxParticipants = maxParticipants,
                DayOfWeek = (float)date.DayOfWeek,
                Month = date.Month,
                Hour = date.Hour,
                IsWeekend = (date.DayOfWeek == DayOfWeek.Saturday || date.DayOfWeek == DayOfWeek.Sunday) ? 1 : 0,
                DaysUntilWorkshop = Math.Max(0, daysUntilWorkshop),
                WorkshopTypeEncoded = typeEncoded,
                PriceToMaxRatio = priceToMaxRatio,
                ActualParticipants = participants
            };
        }

        public bool IsModelTrained()
        {
            return _model != null;
        }
    }
}
