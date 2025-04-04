using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.Log
{
	public class CLog_Report_File_Excel
	{
		private long m_lngAuto_ID;
		private long m_lngChu_Hang_ID;
		private int m_intReport_File_Type_ID;
		private string m_strTen_File;
		private string m_strFile_URL;
		private int m_intdeleted;
		private DateTime? m_dtmCreated;
		private string m_strCreated_By;
		private string m_strCreated_By_Function;
		private DateTime? m_dtmLast_Updated;
		private string m_strLast_Updated_By;
		private string m_strLast_Updated_By_Function;

		private string m_strLog_Report_Add_1;
        private string m_strLog_Report_Add_2;
        private string m_strLog_Report_Add_3;
        private string m_strLog_Report_Add_4;
        private string m_strLog_Report_Add_5;

		private string m_strMa_Chu_Hang;
		private string m_strTen_Chu_Hang;
		private string m_strMa_Kho;
		private string m_strTen_Kho;

        public CLog_Report_File_Excel()
		{
			ResetData();
		}

		public void ResetData()
		{
			m_lngAuto_ID = CConst.INT_VALUE_NULL;
			m_lngChu_Hang_ID = CConst.INT_VALUE_NULL;
			m_intReport_File_Type_ID = CConst.INT_VALUE_NULL;
			m_strTen_File = CConst.STR_VALUE_NULL;
			m_strFile_URL = CConst.STR_VALUE_NULL;
			m_intdeleted = CConst.INT_VALUE_NULL;
			m_dtmCreated = CConst.DTM_VALUE_NULL;
			m_strCreated_By = CConst.STR_VALUE_NULL;
			m_strCreated_By_Function = CConst.STR_VALUE_NULL;
			m_dtmLast_Updated = CConst.DTM_VALUE_NULL;
			m_strLast_Updated_By = CConst.STR_VALUE_NULL;
			m_strLast_Updated_By_Function = CConst.STR_VALUE_NULL;

			m_strLog_Report_Add_1 = CConst.STR_VALUE_NULL;
            m_strLog_Report_Add_2 = CConst.STR_VALUE_NULL;
            m_strLog_Report_Add_3 = CConst.STR_VALUE_NULL;
            m_strLog_Report_Add_4 = CConst.STR_VALUE_NULL;
            m_strLog_Report_Add_5 = CConst.STR_VALUE_NULL;

            m_strMa_Chu_Hang = CConst.STR_VALUE_NULL;
            m_strTen_Chu_Hang = CConst.STR_VALUE_NULL;
            m_strMa_Kho = CConst.STR_VALUE_NULL;
            m_strTen_Kho = CConst.STR_VALUE_NULL;
        }

		public long Auto_ID
		{
			get
			{
				return m_lngAuto_ID;
			}
			set
			{
				m_lngAuto_ID = value;
			}
		}

		public long Chu_Hang_ID
		{
			get
			{
				return m_lngChu_Hang_ID;
			}
			set
			{
				m_lngChu_Hang_ID = value;
			}
		}

		public int Report_File_Type_ID
		{
			get
			{
				return m_intReport_File_Type_ID;
			}
			set
			{
				m_intReport_File_Type_ID = value;
			}
		}

		public string Ten_File
		{
			get
			{
				return m_strTen_File;
			}
			set
			{
				m_strTen_File = value.Trim();
			}
		}

		public string File_URL
		{
			get
			{
				return m_strFile_URL;
			}
			set
			{
				m_strFile_URL = value.Trim();
			}
		}

		public int deleted
		{
			get
			{
				return m_intdeleted;
			}
			set
			{
				m_intdeleted = value;
			}
		}

		public DateTime? Created
		{
			get
			{
				return m_dtmCreated;
			}
			set
			{
				m_dtmCreated = value;
			}
		}

		public string Created_By
		{
			get
			{
				return m_strCreated_By;
			}
			set
			{
				m_strCreated_By = value.Trim();
			}
		}

		public string Created_By_Function
		{
			get
			{
				return m_strCreated_By_Function;
			}
			set
			{
				m_strCreated_By_Function = value.Trim();
			}
		}

		public DateTime? Last_Updated
		{
			get
			{
				return m_dtmLast_Updated;
			}
			set
			{
				m_dtmLast_Updated = value;
			}
		}

		public string Last_Updated_By
		{
			get
			{
				return m_strLast_Updated_By;
			}
			set
			{
				m_strLast_Updated_By = value.Trim();
			}
		}

		public string Last_Updated_By_Function
		{
			get
			{
				return m_strLast_Updated_By_Function;
			}
			set
			{
				m_strLast_Updated_By_Function = value.Trim();
			}
		}

        public string Log_Report_Add_1
        {
            get
            {
                return m_strLog_Report_Add_1;
            }
            set
            {
                m_strLog_Report_Add_1 = value.Trim();
            }
        }

        public string Log_Report_Add_2
        {
            get
            {
                return m_strLog_Report_Add_2;
            }
            set
            {
                m_strLog_Report_Add_2 = value.Trim();
            }
        }

        public string Log_Report_Add_3
        {
            get
            {
                return m_strLog_Report_Add_3;
            }
            set
            {
                m_strLog_Report_Add_3 = value.Trim();
            }
        }

        public string Log_Report_Add_4
        {
            get
            {
                return m_strLog_Report_Add_4;
            }
            set
            {
                m_strLog_Report_Add_4 = value.Trim();
            }
        }

        public string Log_Report_Add_5
        {
            get
            {
                return m_strLog_Report_Add_5;
            }
            set
            {
                m_strLog_Report_Add_5 = value.Trim();
            }
        }

		public string Report_File_Type_Text
        {
            get
            {
                string v_strRes = "";

                switch (Report_File_Type_ID)
                {
                    case (int)EReport_File_Type_ID.Export_Excel: v_strRes = "Export excel"; break;
                }

                return v_strRes;
            }
        }
        public string Ma_Chu_Hang
        {
            get
            {
                return m_strMa_Chu_Hang;
            }
            set
            {
                m_strMa_Chu_Hang = value.Trim();
            }
        }

        public string Ten_Chu_Hang
        {
            get
            {
                return m_strTen_Chu_Hang;
            }
            set
            {
                m_strTen_Chu_Hang = value.Trim();
            }
        }

        public string Ma_Kho
        {
            get
            {
                return m_strMa_Kho;
            }
            set
            {
                m_strMa_Kho = value.Trim();
            }
        }

        public string Ten_Kho
        {
            get
            {
                return m_strTen_Kho;
            }
            set
            {
                m_strTen_Kho = value.Trim();
            }
        }

    }
}
