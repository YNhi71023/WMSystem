using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Controller.DM;
using TKS_Thuc_Tap_V11_Data_Access.Entity.DM;
using TKS_Thuc_Tap_V11_Data_Access.Entity.Sys;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Controller.Cache
{
    public class CCache_NCC
    {
        public static List<CDM_NCC> Arr_Data = new List<CDM_NCC>();

        private static Dictionary<string, CDM_NCC> Dic_Data_Code = new Dictionary<string, CDM_NCC>();
        private static Dictionary<string, CDM_NCC> Dic_Data_Ten_NCC = new Dictionary<string, CDM_NCC>();
        private static Dictionary<long, CDM_NCC> Dic_Data_ID = new Dictionary<long, CDM_NCC>();

        public static void Load_Cache_NCC()
        {
            Arr_Data.Clear();
            Dic_Data_ID.Clear();
            Dic_Data_Code.Clear();
            Dic_Data_Ten_NCC.Clear();
            CDM_NCC_Controller v_objCtrl = new();
            List<CDM_NCC> v_arrTemp_Data = v_objCtrl.FQ_539_NCC_sp_sel_List_For_Cache();

            foreach (CDM_NCC v_objData in v_arrTemp_Data)
                Add_Data(v_objData);
        }

        public static void Add_Data(CDM_NCC p_objData)
        {
            if (Dic_Data_ID.ContainsKey(p_objData.Auto_ID) == true || p_objData.Auto_ID == 0)
                return;

            Dic_Data_ID.Add(p_objData.Auto_ID, p_objData);
            Arr_Data.Add(p_objData);

            if (Dic_Data_Code.ContainsKey(p_objData.Ma_NCC.ToLower()) == false)
                Dic_Data_Code.Add(p_objData.Ma_NCC.ToLower(), p_objData);

            if (Dic_Data_Ten_NCC.ContainsKey(p_objData.Ten_NCC.ToLower()) == false)
                Dic_Data_Ten_NCC.Add(p_objData.Ten_NCC.ToLower(), p_objData);
        }

        public static void Update_Data(CDM_NCC p_objData)
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

            CDM_NCC v_objData = Dic_Data_ID[p_iAuto_ID];

            Arr_Data.Remove(v_objData);
            Dic_Data_ID.Remove(p_iAuto_ID);

            Dic_Data_Code.Remove(v_objData.Ma_NCC.ToLower());
            Dic_Data_Ten_NCC.Remove(v_objData.Ten_NCC.ToLower());
        }

        public static CDM_NCC Get_Data_By_ID(long p_iID)
        {
            if (Dic_Data_ID.ContainsKey(p_iID) == true)
                return Dic_Data_ID[p_iID];

            return null;
        }

        public static CDM_NCC Get_Data_By_Ma_NCC(string p_strCode)
        {
            if (Dic_Data_Code.ContainsKey(p_strCode.ToLower()) == true)
                return Dic_Data_Code[p_strCode.ToLower()];

            return null;
        }

        public static CDM_NCC Get_Data_By_Ten_NCC(string p_strTen_NCC)
        {
            if (Dic_Data_Ten_NCC.ContainsKey(p_strTen_NCC.ToLower()) == true)
                return Dic_Data_Ten_NCC[p_strTen_NCC.ToLower()];

            return null;
        }

        public static List<CDM_NCC> List_Data()
        {
            return Arr_Data.OrderBy(it => it.Ten_NCC).ToList();
        }
    }
}
