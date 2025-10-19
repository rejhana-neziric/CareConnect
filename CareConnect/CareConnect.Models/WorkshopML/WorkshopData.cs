using Microsoft.ML.Data;
using System;
using System.Collections.Generic;
using System.Text;

namespace CareConnect.Models.WorkshopML
{
    public class WorkshopData
    {
        [LoadColumn(0)]
        public float Price { get; set; }

        [LoadColumn(1)]
        public float MaxParticipants { get; set; }

        [LoadColumn(2)]
        public float DayOfWeek { get; set; } // 0-6 (Monday-Sunday)

        [LoadColumn(3)]
        public float Month { get; set; } // 1-12

        [LoadColumn(4)]
        public float Hour { get; set; } // 0-23

        [LoadColumn(5)]
        public float IsWeekend { get; set; } // 0 or 1

        [LoadColumn(6)]
        public float DaysUntilWorkshop { get; set; } // Days from creation to workshop date

        [LoadColumn(7)]
        public float WorkshopTypeEncoded { get; set; }

        [LoadColumn(8)]
        public float PriceToMaxRatio { get; set; } // Price / MaxParticipants

        [LoadColumn(9)]
        [ColumnName("Label")]
        public float ActualParticipants { get; set; }
    }
}
