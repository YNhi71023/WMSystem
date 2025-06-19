using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.DM
{
    public class CDM_Bao_Cao_Ton_Kho
    {
        private long m_lngAuto_ID;
        private long m_lngSan_Pham_ID;
        private string m_strMa_San_Pham;
        private string m_strTen_San_Pham;
        private long m_lngSL_Dau_Ky;
        private long m_lngSL_Nhap;
        private long m_lngSL_Xuat;
        private long m_lngSL_Cuoi_Ky;
        public CDM_Bao_Cao_Ton_Kho()
        {
            ResetData();
        }
        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_lngSan_Pham_ID = CConst.INT_VALUE_NULL;
            m_strMa_San_Pham = CConst.STR_VALUE_NULL;
            m_strTen_San_Pham = CConst.STR_VALUE_NULL;
            SL_Dau_Ky = CConst.INT_VALUE_NULL;
            m_lngSL_Nhap = CConst.INT_VALUE_NULL;
            m_lngSL_Xuat = CConst.INT_VALUE_NULL;
            SL_Cuoi_Ky = CConst.INT_VALUE_NULL;
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
        public string Ma_San_Pham
        {
            get
            {
                return m_strMa_San_Pham;
            }
            set
            {
                m_strMa_San_Pham = value.Trim();
            }
        }
        public string Ten_San_Pham
        {
            get
            {
                return m_strTen_San_Pham;
            }
            set
            {
                m_strTen_San_Pham = value.Trim();
            }
        }
        public long SL_Dau_Ky
        {
            get
            {
                return m_lngSL_Dau_Ky;
            }
            set
            {
                m_lngSL_Dau_Ky = value;
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
        public long SL_Xuat
        {
            get
            {
                return m_lngSL_Xuat;
            }
            set
            {
                m_lngSL_Xuat = value;
            }
        }
        public long SL_Cuoi_Ky
        {
            get
            {
                return m_lngSL_Cuoi_Ky;
            }
            set
            {
                m_lngSL_Cuoi_Ky = value;
            }
        }


    }
}