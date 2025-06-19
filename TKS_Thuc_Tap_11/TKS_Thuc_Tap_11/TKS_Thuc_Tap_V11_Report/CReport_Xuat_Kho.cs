using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using TKS_Thuc_Tap_V11_Data_Access.Controller.DM;
using TKS_Thuc_Tap_V11_Data_Access.Entity.Common;
using TKS_Thuc_Tap_V11_Data_Access.Entity.DM;
using TKS_Thuc_Tap_V11_Data_Access.Utility;
namespace TKS_Thuc_Tap_V11_Report
{
    [DataObject]
    public class CReport_Xuat_Kho
    {
        [DataObjectMethod(DataObjectMethodType.Select)]
        public CDM_Xuat_Kho rptReport_Header(long p_iAuto_ID)
        {
            CDM_Xuat_Kho_Controller v_ojbCtr = new();
            return v_ojbCtr.FQ_728_XK_sp_sel_Get_By_ID(p_iAuto_ID);
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public List<CDM_Phieu_Xuat_Kho> rptReport_Content(long p_iAuto_ID)
        {
            CDM_Phieu_Xuat_Kho_Controller v_ojbCtr = new();
            return v_ojbCtr.F3001_sp_sel_List_By_Xuat_Kho_ID(p_iAuto_ID);
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public double rptReport_TotalQuantity(long p_iAuto_ID)
        {
            CDM_Phieu_Xuat_Kho_Controller v_ojbCtr = new();
            var v_arrData = v_ojbCtr.F3001_sp_sel_List_By_Xuat_Kho_ID(p_iAuto_ID);

            if (v_arrData == null || !v_arrData.Any())
                return 0; // Trả về 0 nếu không có dữ liệu

            return v_arrData.Sum(x => x.SL_Xuat); // Tính tổng số lượng xuất kho
        }

        [DataObjectMethod(DataObjectMethodType.Select)]
        public string rptReport_TotalQuantityInWords(long p_iAuto_ID)
        {
            double v_dblTotal = rptReport_TotalQuantity(p_iAuto_ID);
            CNumber v_objNumber = new CNumber();
            return v_objNumber.ReadInt(((long)v_dblTotal).ToString(), "đơn vị");
        }
    }
}
