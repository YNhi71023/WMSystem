using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Controller.DM;
using TKS_Thuc_Tap_V11_Data_Access.Entity.DM;

namespace TKS_Thuc_Tap_V11_Data_Access.Controller.Cache
{
    public class CCache_Xuat_Kho
    {
        public static List<CDM_Xuat_Kho> Arr_Data = new List<CDM_Xuat_Kho>();

        private static Dictionary<string, CDM_Xuat_Kho> Dic_Data_Code = new Dictionary<string, CDM_Xuat_Kho>();
        //private static Dictionary<string, CDM_Xuat_Kho> Dic_Data_Ten_Xuat_Kho = new Dictionary<string, CDM_Xuat_Kho>();
        private static Dictionary<long, CDM_Xuat_Kho> Dic_Data_ID = new Dictionary<long, CDM_Xuat_Kho>();
        public static void Load_Cache_Xuat_Kho()
        {
            Arr_Data.Clear();
            Dic_Data_ID.Clear();
            Dic_Data_Code.Clear();
            //Dic_Data_Ten_Xuat_Kho.Clear();
            CDM_Xuat_Kho_Controller v_objCtrl = new();
            List<CDM_Xuat_Kho> v_arrTemp_Data = v_objCtrl.FQ_728_XK_sp_sel_List_For_Cache();

            foreach (CDM_Xuat_Kho v_objData in v_arrTemp_Data)
                Add_Data(v_objData);
        }
        public static void Add_Data(CDM_Xuat_Kho p_objData)
        {
            if (Dic_Data_ID.ContainsKey(p_objData.Auto_ID) == true || p_objData.Auto_ID == 0)
                return;

            Dic_Data_ID.Add(p_objData.Auto_ID, p_objData);
            Arr_Data.Add(p_objData);

            if (Dic_Data_Code.ContainsKey(p_objData.So_Phieu_Xuat_Kho.ToLower()) == false)
                Dic_Data_Code.Add(p_objData.So_Phieu_Xuat_Kho.ToLower(), p_objData);

            //if (Dic_Data_Ten_Xuat_Kho.ContainsKey(p_objData.Ten_Xuat_Kho.ToLower()) == false)
            //    Dic_Data_Ten_Xuat_Kho.Add(p_objData.Ten_Xuat_Kho.ToLower(), p_objData);
        }
        public static void Update_Data(CDM_Xuat_Kho p_objData)
        {
            if (Dic_Data_ID.ContainsKey(p_objData.Auto_ID) == false || p_objData.Auto_ID == 0)
                return;

            Delete_Data(p_objData.Auto_ID);
            Add_Data(p_objData);
        }

        public static void Delete_Data(long p_iAuto_ID)
        {
            if (Dic_Data_ID.ContainsKey(p_iAuto_ID) == false || p_iAuto_ID == 0)
                return;

            CDM_Xuat_Kho v_objData = Dic_Data_ID[p_iAuto_ID];

            Arr_Data.Remove(v_objData);
            Dic_Data_ID.Remove(p_iAuto_ID);

            Dic_Data_Code.Remove(v_objData.So_Phieu_Xuat_Kho.ToLower());
            // Dic_Data_Ten_Xuat_Kho.Remove(v_objData.Ten_Xuat_Kho.ToLower());
        }

        public static CDM_Xuat_Kho Get_Data_By_ID(long p_iID)
        {
            if (Dic_Data_ID.ContainsKey(p_iID) == true)
                return Dic_Data_ID[p_iID];

            return null;
        }


        public static CDM_Xuat_Kho Get_Data_By_So_Phieu_Xuat_Kho(string p_strSo_Phieu_Xuat_Kho)
        {
            if (Dic_Data_Code.ContainsKey(p_strSo_Phieu_Xuat_Kho.ToLower()) == true)
                return Dic_Data_Code[p_strSo_Phieu_Xuat_Kho.ToLower()];

            return null;
        }

        public static List<CDM_Xuat_Kho> List_Data()
        {
            return Arr_Data.OrderBy(it => it.So_Phieu_Xuat_Kho).ToList();
        }
    }
}
