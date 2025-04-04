using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.Log
{
    public class CLog_API
    {
        private long m_lngAuto_ID;
        private string m_strKey_No;
        private string m_strAPI_Source_Name;
        private string m_strAPI_Function_Name;
        private string m_strDescription;
        private int m_intTrang_Thai_ID;
        private string m_strLink_URL;
        private int m_intdeleted;
        private DateTime? m_dtmCreated;
        private string m_strCreated_By;
        private string m_strCreated_By_Function;
        private DateTime? m_dtmLast_Updated;
        private string m_strLast_Updated_By;
        private string m_strLast_Updated_By_Function;

        public CLog_API()
        {
            ResetData();
        }

        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_strKey_No = CConst.STR_VALUE_NULL;
            m_strAPI_Source_Name = CConst.STR_VALUE_NULL;
            m_strAPI_Function_Name = CConst.STR_VALUE_NULL;
            m_strDescription = CConst.STR_VALUE_NULL;
            m_intTrang_Thai_ID = CConst.INT_VALUE_NULL;
            m_strLink_URL = CConst.STR_VALUE_NULL;
            m_intdeleted = CConst.INT_VALUE_NULL;
            m_dtmCreated = CConst.DTM_VALUE_NULL;
            m_strCreated_By = CConst.STR_VALUE_NULL;
            m_strCreated_By_Function = CConst.STR_VALUE_NULL;
            m_dtmLast_Updated = CConst.DTM_VALUE_NULL;
            m_strLast_Updated_By = CConst.STR_VALUE_NULL;
            m_strLast_Updated_By_Function = CConst.STR_VALUE_NULL;
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

        public string Key_No
        {
            get
            {
                return m_strKey_No;
            }
            set
            {
                m_strKey_No = value.Trim();
            }
        }

        public string API_Source_Name
        {
            get
            {
                return m_strAPI_Source_Name;
            }
            set
            {
                m_strAPI_Source_Name = value.Trim();
            }
        }

        public string API_Function_Name
        {
            get
            {
                return m_strAPI_Function_Name;
            }
            set
            {
                m_strAPI_Function_Name = value.Trim();
            }
        }

        public string Description
        {
            get
            {
                return m_strDescription;
            }
            set
            {
                m_strDescription = value.Trim();
            }
        }

        public int Trang_Thai_ID
        {
            get
            {
                return m_intTrang_Thai_ID;
            }
            set
            {
                m_intTrang_Thai_ID = value;
            }
        }

        public string Link_URL
        {
            get
            {
                return m_strLink_URL;
            }
            set
            {
                m_strLink_URL = value.Trim();
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

        public string Key_All
        {
            get
            {
                return CUtility.Tao_Key(Key_No, API_Source_Name, API_Function_Name);
            }
        }

		public string Trang_Thai_Text
		{
			get
			{
				string v_strRes = "";

				switch (Trang_Thai_ID)
				{
					case (int)ECommon_Status_ID.Completed: v_strRes = "Completed"; break;
					case (int)ECommon_Status_ID.Error: v_strRes = "Error"; break;
					case (int)ECommon_Status_ID.Confirmed: v_strRes = "Confirmed"; break;
				}

				return v_strRes;
			}
		}

		public string Trang_Thai_HTML
        {
            get
            {
				string v_strRes = "";

				switch (Trang_Thai_ID)
				{
					case (int)ECommon_Status_ID.Completed: v_strRes = "<span class=\"badge bg-success\">"+ Trang_Thai_Text+"</span>"; break;
					case (int)ECommon_Status_ID.Error: v_strRes = "<span class=\"badge bg-danger\">"+ Trang_Thai_Text + "</span>"; break;
					case (int)ECommon_Status_ID.Confirmed: v_strRes = "<span class=\"badge bg-info\">"+ Trang_Thai_Text + "</span>"; break;
				}

				return v_strRes;
			}
        }

	}
}
