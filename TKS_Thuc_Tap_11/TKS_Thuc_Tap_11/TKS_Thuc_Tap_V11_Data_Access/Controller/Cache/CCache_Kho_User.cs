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
    public class CCache_Kho_User
    {
        public static List<CDM_Kho_User> Arr_Data = new List<CDM_Kho_User>();

        private static Dictionary<string, List<CDM_Kho_User>> Dic_Data_User = new Dictionary<string, List<CDM_Kho_User>>();
        private static Dictionary<long, CDM_Kho_User> Dic_Data_ID = new Dictionary<long, CDM_Kho_User>();

        public static void Load_Cache_Kho_User()
        {
            Arr_Data.Clear();
            Dic_Data_User.Clear();
            Dic_Data_ID.Clear();

            CDM_Kho_User_Controller v_objCtrData = new CDM_Kho_User_Controller();
            List<CDM_Kho_User> v_arrTemp_Data = v_objCtrData.FQ_117_KU_sp_sel_List_For_Cache();

            foreach (CDM_Kho_User v_objData in v_arrTemp_Data)
                Add_Data(v_objData);
        }

        public static void Add_Data(CDM_Kho_User p_objData)
        {
            if (Dic_Data_ID.ContainsKey(p_objData.Auto_ID) == true || p_objData.Auto_ID == 0)
                return;

            Dic_Data_ID.Add(p_objData.Auto_ID, p_objData);
            Arr_Data.Add(p_objData);

            if (Dic_Data_User.ContainsKey(p_objData.Ma_Dang_Nhap.ToLower()) == false)
                Dic_Data_User.Add(p_objData.Ma_Dang_Nhap.ToLower(), new List<CDM_Kho_User>());

            List<CDM_Kho_User> v_arrTemp = Dic_Data_User[p_objData.Ma_Dang_Nhap.ToLower()];
            v_arrTemp.Add(p_objData);
        }

        public static void Update_Data(CDM_Kho_User p_objData)
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

            CDM_Kho_User v_objData = Dic_Data_ID[p_iAuto_ID];

            Arr_Data.Remove(v_objData);
            Dic_Data_ID.Remove(p_iAuto_ID);

            Dic_Data_User[v_objData.Ma_Dang_Nhap.ToLower()].Remove(v_objData);
        }

        public static CDM_Kho_User Get_Data_By_ID(long p_iID)
        {
            if (Dic_Data_ID.ContainsKey(p_iID) == true)
                return Dic_Data_ID[p_iID];

            return null;
        }

        public static List<CDM_Kho_User> List_Data_By_User(string p_strMa_Dang_Nhap)
        {
            if (Dic_Data_User.ContainsKey(p_strMa_Dang_Nhap.ToLower()) == true)
                return Dic_Data_User[p_strMa_Dang_Nhap.ToLower()].ToList();

            return new List<CDM_Kho_User>();
        }
    }
}
