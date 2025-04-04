using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.Log
{
    public class CLog_Nhat_Ky_Truy_Cap_Chuc_Nang
    {
        private long m_lngAuto_ID;
        private string m_strMa_Dang_Nhap;
        private string m_strMa_Chuc_Nang;
        private string m_strTen_Chuc_Nang;
        private int m_intdeleted;
        private DateTime? m_dtmCreated;
        private string m_strCreated_By;

        public CLog_Nhat_Ky_Truy_Cap_Chuc_Nang()
        {
            ResetData();
        }

        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_strMa_Dang_Nhap = CConst.STR_VALUE_NULL;
            m_strMa_Chuc_Nang = CConst.STR_VALUE_NULL;
            m_strTen_Chuc_Nang = CConst.STR_VALUE_NULL;
            m_intdeleted = CConst.INT_VALUE_NULL;
            m_dtmCreated = CConst.DTM_VALUE_NULL;
            m_strCreated_By = CConst.STR_VALUE_NULL;
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

        public string Ma_Dang_Nhap
        {
            get
            {
                return m_strMa_Dang_Nhap;
            }
            set
            {
                m_strMa_Dang_Nhap = value.Trim();
            }
        }

        public string Ma_Chuc_Nang
        {
            get
            {
                return m_strMa_Chuc_Nang;
            }
            set
            {
                m_strMa_Chuc_Nang = value.Trim();
            }
        }

        public string Ten_Chuc_Nang
        {
            get
            {
                return m_strTen_Chuc_Nang;
            }
            set
            {
                m_strTen_Chuc_Nang = value.Trim();
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
    }
}
