using CareConnect.Models.Requests;
using CareConnect.Models.WorkshopML;
using Microsoft.ML.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CareConnect.Services.WorkshopML
{
    public interface IWorkshopMLService
    {
        public void TrainModel(List<Database.Workshop> historicalWorkshops);

        public WorkshopPrediction PredictParticipants(WorkshopInsertRequest workshop);

        public RegressionMetrics? EvaluateModel(List<Database.Workshop> testWorkshops);

        public bool IsModelTrained();
    }
}
