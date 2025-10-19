using Microsoft.ML.Data;
using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.WorkshopML
{
    public class WorkshopPrediction
    {
        [ColumnName("Score")]
        public float PredictedParticipants { get; set; }
    }
}
