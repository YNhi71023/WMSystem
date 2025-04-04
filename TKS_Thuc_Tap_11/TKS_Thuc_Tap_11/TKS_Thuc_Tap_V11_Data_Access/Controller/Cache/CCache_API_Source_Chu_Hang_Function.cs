﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.Controller.Sys;
using TKS_Thuc_Tap_V11_Data_Access.Entity.Sys;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Controller.Cache
{
    public class CCache_API_Source_Chu_Hang_Function
    {
        private static List<CSys_API_Source_Chu_Hang_Function> Arr_Data = new List<CSys_API_Source_Chu_Hang_Function>();

        private static Dictionary<string, CSys_API_Source_Chu_Hang_Function> Dic_Data_Code = new Dictionary<string, CSys_API_Source_Chu_Hang_Function>();
        private static Dictionary<long, CSys_API_Source_Chu_Hang_Function> Dic_Data_ID = new Dictionary<long, CSys_API_Source_Chu_Hang_Function>();

        public static void Load_Cache_API_Source_Chu_Hang_Function()
        {
            Arr_Data.Clear();
            Dic_Data_ID.Clear();
            Dic_Data_Code.Clear();

            CSys_API_Source_Chu_Hang_Function_Controller v_objCtrData = new CSys_API_Source_Chu_Hang_Function_Controller();
            //List<CSys_API_Source_Chu_Hang_Function> v_arrTemp_Data = v_objCtrData.FCombo_List_Sys_API_Source_Chu_Hang_Function(); //
            List<CSys_API_Source_Chu_Hang_Function> v_arrTemp_Data = v_objCtrData.FQ_503_ASCHF_sp_sel_List_For_Cache(); //

            foreach (CSys_API_Source_Chu_Hang_Function v_objData in v_arrTemp_Data)
                Add_Data(v_objData);
        }

        public static void Add_Data(CSys_API_Source_Chu_Hang_Function p_objData)
        {
            if (Dic_Data_ID.ContainsKey(p_objData.Auto_ID) == true || p_objData.Auto_ID == 0)
                return;

            Dic_Data_ID.Add(p_objData.Auto_ID, p_objData);
            Arr_Data.Add(p_objData);

            string v_strKey_Code = CUtility.Tao_Key(p_objData.API_Source_Chu_Hang_ID, p_objData.API_Source_Function_ID);
            if (Dic_Data_Code.ContainsKey(v_strKey_Code) == false)
                Dic_Data_Code.Add(v_strKey_Code, p_objData);
        }

        public static void Update_Data(CSys_API_Source_Chu_Hang_Function p_objData)
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

            CSys_API_Source_Chu_Hang_Function v_objData = Dic_Data_ID[p_iAuto_ID];

            Arr_Data.Remove(v_objData);
            Dic_Data_ID.Remove(p_iAuto_ID);

            string v_strKey_Code = CUtility.Tao_Key(v_objData.API_Source_Chu_Hang_ID, v_objData.API_Source_Function_ID);
            Dic_Data_Code.Remove(v_strKey_Code);
        }

        public static CSys_API_Source_Chu_Hang_Function Get_Data_By_ID(long p_iID)
        {
            if (Dic_Data_ID.ContainsKey(p_iID) == true)
                return Dic_Data_ID[p_iID];

            return null;
        }

        public static CSys_API_Source_Chu_Hang_Function Get_Data_By_Code(long p_iAPI_Source_Chu_Hang_ID, long p_iAPI_Source_Function_ID)
        {
            string v_strKey_Code = CUtility.Tao_Key(p_iAPI_Source_Chu_Hang_ID, p_iAPI_Source_Function_ID);

            if (Dic_Data_Code.ContainsKey(v_strKey_Code) == true)
                return Dic_Data_Code[v_strKey_Code];

            return null;
        }

        public static List<CSys_API_Source_Chu_Hang_Function> List_Data()
        {
            return Arr_Data.ToList();
        }
       
    }
}
