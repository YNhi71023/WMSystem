using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.DM
{
    public class CDM_Phieu_Nhap_Kho
    {
        private long m_lngAuto_ID;
        private long m_lngNhap_Kho_ID;
        private long m_lngSan_Pham_ID;
        private long m_lngSL_Nhap;
        private long m_lngDon_Gia_Nhap;
        private int m_intdeleted;
        private DateTime? m_dtmCreated;
        private string m_strCreated_By;
        private string m_strCreated_By_Function;
        private DateTime? m_dtmLast_Updated;
        private string m_strLast_Updated_By;
        private string m_strLast_Updated_By_Function;

        private string m_strLast_Updated_API;
        public CDM_Phieu_Nhap_Kho()
        {
            ResetData();
        }

        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_lngNhap_Kho_ID = CConst.INT_VALUE_NULL;
            m_lngSan_Pham_ID = CConst.INT_VALUE_NULL;
            m_lngSL_Nhap = CConst.INT_VALUE_NULL;
            m_lngDon_Gia_Nhap = CConst.INT_VALUE_NULL;
            m_intdeleted = CConst.INT_VALUE_NULL;
            m_dtmCreated = CConst.DTM_VALUE_NULL;
            m_strCreated_By = CConst.STR_VALUE_NULL;
            m_strCreated_By_Function = CConst.STR_VALUE_NULL;
            m_dtmLast_Updated = CConst.DTM_VALUE_NULL;
            m_strLast_Updated_By = CConst.STR_VALUE_NULL;
            m_strLast_Updated_By_Function = CConst.STR_VALUE_NULL;

            m_strLast_Updated_API = CConst.STR_VALUE_NULL;
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
        public long Nhap_Kho_ID
        {
            get
            {
                return m_lngNhap_Kho_ID;
            }
            set
            {
                m_lngNhap_Kho_ID = value;
            }
        }
        public long San_Pham_ID
        {
            get
            {
                return m_lngSan_Pham_ID;
            }
            set
            {
                m_lngSan_Pham_ID = value;
            }
        }
        public long SL_Nhap
        {
            get
            {
                return m_lngSL_Nhap;
            }
            set
            {
                m_lngSL_Nhap = value;
            }
        }
        public long Don_Gia_Nhap
        {
            get
            {
                return m_lngDon_Gia_Nhap;
            }
            set
            {
                m_lngDon_Gia_Nhap = value;
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


        public string Last_Updated_API
        {
            get
            {
                return m_strLast_Updated_API;

            }
            set
            {
                m_strLast_Updated_API = value.Trim();

            }
        }
    }
}
