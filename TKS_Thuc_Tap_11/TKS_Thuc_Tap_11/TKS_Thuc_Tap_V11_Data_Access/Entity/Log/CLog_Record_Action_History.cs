using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.Log
{
    public class CLog_Record_Action_History
    {
        private long m_lngAuto_ID;
        private long m_lngRef_ID;
        private string m_strTen_Hanh_Dong;
        private string m_strTen_Moi_Truong;
        private string m_strMa_Chuc_Nang;
		private string m_strTen_Chuc_Nang;
		private string m_strNoi_Dung_Action;
		private int m_intdeleted;
        private DateTime? m_dtmCreated;
        private string m_strCreated_By;

        public CLog_Record_Action_History()
        {
            ResetData();
        }

        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_lngRef_ID = CConst.INT_VALUE_NULL;
            m_strTen_Hanh_Dong = CConst.STR_VALUE_NULL;
            m_strTen_Moi_Truong = CConst.STR_VALUE_NULL;
            m_strMa_Chuc_Nang = CConst.STR_VALUE_NULL;
			m_strTen_Chuc_Nang = CConst.STR_VALUE_NULL;
			m_strNoi_Dung_Action = CConst.STR_VALUE_NULL;
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

        public long Ref_ID
        {
            get
            {
                return m_lngRef_ID;
            }
            set
            {
                m_lngRef_ID = value;
            }
        }

        public string Ten_Hanh_Dong
        {
            get
            {
                return m_strTen_Hanh_Dong;
            }
            set
            {
                m_strTen_Hanh_Dong = value.Trim();
            }
        }

        public string Ten_Moi_Truong
        {
            get
            {
                return m_strTen_Moi_Truong;
            }
            set
            {
                m_strTen_Moi_Truong = value.Trim();
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

		public string Noi_Dung_Action
		{
			get
			{
				return m_strNoi_Dung_Action;
			}
			set
			{
				m_strNoi_Dung_Action = value.Trim();
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

        public string Ref_Text
        {
            get
            {
                return Ref_ID.ToString("##########");
            }
        }
    }
}
