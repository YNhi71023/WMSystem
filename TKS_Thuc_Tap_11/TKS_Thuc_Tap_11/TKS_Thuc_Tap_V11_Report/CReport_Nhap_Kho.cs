using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using TKS_Thuc_Tap_V11_Data_Access.Controller.Cache;
using TKS_Thuc_Tap_V11_Data_Access.Controller.DM;
using TKS_Thuc_Tap_V11_Data_Access.Entity.Common;
using TKS_Thuc_Tap_V11_Data_Access.Entity.DM;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Report
{
    [DataObject]
    public class CReport_Nhap_Kho
    {
        [DataObjectMethod(DataObjectMethodType.Select)]
        public CDM_Nhap_Kho rptReport_Header(long p_iAuto_ID)
        {
            CDM_Nhap_Kho_Controller v_ojbCtr = new();
            return v_ojbCtr.FQ_718_NK_sp_sel_Get_By_ID(p_iAuto_ID);
            //return v_ojbCtr.FQ_718_NK_sp_sel_Get_By_ID(p_iAuto_ID);
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public List<CDM_Phieu_Nhap_Kho> rptReport_Content(long p_iNhap_Kho_ID)
        {
            CDM_Phieu_Nhap_Kho_Controller v_ojbCtr = new();
            return v_ojbCtr.F7001_sp_sel_List_By_Nhap_Kho_ID(p_iNhap_Kho_ID);
            //return v_ojbCtr.F3001_sp_sel_List_By_Nhap_Kho_ID(p_iAuto_ID);
        }


        [DataObjectMethod(DataObjectMethodType.Select)]
        public double rptReport_TotalPrice(long p_iAuto_ID)
        {
            CDM_Phieu_Nhap_Kho_Controller v_ojbCtr = new();
            var v_arrData = v_ojbCtr.F7001_sp_sel_List_By_Nhap_Kho_ID(p_iAuto_ID);

            if (v_arrData == null || !v_arrData.Any())
                return 0;
            return 1;
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public string rptReport_TotalPriceInWords(long p_iAuto_ID)
        {
            double v_dblTotal = rptReport_TotalPrice(p_iAuto_ID);
            CNumber v_objNumber = new CNumber();
            return v_objNumber.ReadInt(((long)v_dblTotal).ToString(), "đồng");


        }
    }
}
