﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Entity.Sys;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Entity.DM
{
    public class CDM_Nhap_Kho
    {
        private long m_lngAuto_ID;
        private string m_strSo_Phieu_Nhap_Kho;
        private long m_lngKho_ID;
        private long m_lngNCC_ID;
        private DateTime? m_dtmNgay_Nhap_Kho;
        private string m_strGhi_Chu;
        private int m_intdeleted;
        private DateTime? m_dtmCreated;
        private string m_strCreated_By;
        private string m_strCreated_By_Function;
        private DateTime? m_dtmLast_Updated;
        private string m_strLast_Updated_By;
        private string m_strLast_Updated_By_Function;

        private string m_strLast_Updated_API;
        private List<CDM_Phieu_Nhap_Kho> m_arrPhieu_Nhap_Kho;
        public CDM_Nhap_Kho()
        {
            ResetData();
        }

        public void ResetData()
        {
            m_lngAuto_ID = CConst.INT_VALUE_NULL;
            m_strSo_Phieu_Nhap_Kho = CConst.STR_VALUE_NULL;
            m_lngKho_ID = CConst.INT_VALUE_NULL;
            m_lngNCC_ID = CConst.INT_VALUE_NULL;
            m_dtmNgay_Nhap_Kho = CConst.DTM_VALUE_NULL;
            m_strGhi_Chu = CConst.STR_VALUE_NULL;
            m_intdeleted = CConst.INT_VALUE_NULL;
            m_dtmCreated = CConst.DTM_VALUE_NULL;
            m_strCreated_By = CConst.STR_VALUE_NULL;
            m_strCreated_By_Function = CConst.STR_VALUE_NULL;
            m_dtmLast_Updated = CConst.DTM_VALUE_NULL;
            m_strLast_Updated_By = CConst.STR_VALUE_NULL;
            m_strLast_Updated_By_Function = CConst.STR_VALUE_NULL;

            m_strLast_Updated_API = CConst.STR_VALUE_NULL;
            m_arrPhieu_Nhap_Kho = new List<CDM_Phieu_Nhap_Kho>();
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

        public string So_Phieu_Nhap_Kho
        {
            get
            {
                return m_strSo_Phieu_Nhap_Kho;
            }
            set
            {
                m_strSo_Phieu_Nhap_Kho = value.Trim();
            }
        }
        public long Kho_ID
        {
            get
            {
                return m_lngKho_ID;
            }
            set
            {
                m_lngKho_ID = value;
            }
        }
        public long NCC_ID
        {
            get
            {
                return m_lngNCC_ID;
            }
            set
            {
                m_lngNCC_ID = value;
            }
        }
      
        public DateTime? Ngay_Nhap_Kho
        {
            get
            {
                return m_dtmNgay_Nhap_Kho;
            }
            set
            {
                m_dtmNgay_Nhap_Kho = value;
            }
        }

        public string Ghi_Chu
        {
            get
            {
                return m_strGhi_Chu;
            }
            set
            {
                m_strGhi_Chu = value.Trim();
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
        public List<CDM_Phieu_Nhap_Kho> Phieu_Nhap_Kho
        {
            get
            {
                return m_arrPhieu_Nhap_Kho;
            }
            set
            {
                m_arrPhieu_Nhap_Kho = value;
            }
        }
    }
}
