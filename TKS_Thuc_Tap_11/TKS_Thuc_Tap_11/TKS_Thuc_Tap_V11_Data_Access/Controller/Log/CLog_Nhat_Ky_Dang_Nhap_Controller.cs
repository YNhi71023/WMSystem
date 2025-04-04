using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using TKS_Thuc_Tap_V11_Data_Access.DataLayer;
using TKS_Thuc_Tap_V11_Data_Access.Entity.Log;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Controller.Log
{
    public class CLog_Nhat_Ky_Dang_Nhap_Controller
    {
        public List<CLog_Nhat_Ky_Dang_Nhap> FQ_423_NKDN_sp_sel_List_By_Created(DateTime? p_dtmFrom, DateTime? p_dtmTo)
        {
            List<CLog_Nhat_Ky_Dang_Nhap> v_arrRes = new List<CLog_Nhat_Ky_Dang_Nhap>();
            DataTable v_dt = new DataTable();

            try
            {
                p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
                p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_423_NKDN_sp_sel_List_By_Created", p_dtmFrom, p_dtmTo);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_Nhat_Ky_Dang_Nhap v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Dang_Nhap>(v_row);
                    v_arrRes.Add(v_objRes);
                }
            }

            catch (Exception)
            {
                throw;
            }

            finally
            {
                v_dt.Dispose();
            }

            return v_arrRes;
        }

        public CLog_Nhat_Ky_Dang_Nhap FQ_423_NKDN_sp_sel_Get_By_ID(long p_iID)
        {
            CLog_Nhat_Ky_Dang_Nhap v_objRes = null;
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_423_NKDN_sp_sel_Get_By_ID", p_iID);

                if (v_dt.Rows.Count > 0)
                {
                    v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Dang_Nhap>(v_dt.Rows[0]);
                }
            }

            catch (Exception)
            {
                throw;
            }

            finally
            {
                v_dt.Dispose();
            }

            return v_objRes;
        }

        public long FQ_423_NKDN_sp_ins_Insert(CLog_Nhat_Ky_Dang_Nhap p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_423_NKDN_sp_ins_Insert",
                    p_objData.Ma_Dang_Nhap, p_objData.IP, p_objData.User_Agent, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
            }

            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public void FQ_423_NKDN_sp_upd_Update(CLog_Nhat_Ky_Dang_Nhap p_objData)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_423_NKDN_sp_upd_Update", p_objData.Auto_ID,
                    p_objData.Ma_Dang_Nhap, p_objData.IP, p_objData.User_Agent, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
            }

            catch (Exception)
            {
                throw;
            }
        }

        public void FQ_423_NKDN_sp_upd_Update(SqlConnection p_conn, SqlTransaction p_trans, CLog_Nhat_Ky_Dang_Nhap p_objData)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_423_NKDN_sp_upd_Update", p_objData.Auto_ID,
                    p_objData.Ma_Dang_Nhap, p_objData.IP, p_objData.User_Agent, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
            }

            catch (Exception)
            {
                throw;
            }
        }

        public void FQ_423_NKDN_sp_del_Delete_By_ID(long p_iAuto_ID, string p_strLast_Updated_By, string p_strLast_Updated_By_Function)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_423_NKDN_sp_del_Delete_By_ID", p_iAuto_ID, p_strLast_Updated_By, p_strLast_Updated_By_Function);
            }

            catch (Exception)
            {
                throw;
            }
        }

        //public List<CLog_Nhat_Ky_Dang_Nhap> List_Log_Nhat_Ky_Dang_Nhap()
        //{
        //    List<CLog_Nhat_Ky_Dang_Nhap> v_arrRes = new List<CLog_Nhat_Ky_Dang_Nhap>();
        //    DataTable v_dt = new DataTable();

        //    try
        //    {
        //        CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "sp_sel_List_Log_Nhat_Ky_Dang_Nhap");

        //        foreach (DataRow v_row in v_dt.Rows)
        //        {
        //            CLog_Nhat_Ky_Dang_Nhap v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Dang_Nhap>(v_row);
        //            v_arrRes.Add(v_objRes);
        //        }
        //    }

        //    catch (Exception)
        //    {
        //        throw;
        //    }

        //    finally
        //    {
        //        v_dt.Dispose();
        //    }

        //    return v_arrRes;
        //}

        //public CLog_Nhat_Ky_Dang_Nhap Get_Log_Nhat_Ky_Dang_Nhap_By_ID(long p_iID)
        //{
        //    CLog_Nhat_Ky_Dang_Nhap v_objRes = null;
        //    DataTable v_dt = new DataTable();

        //    try
        //    {
        //        CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "sp_sel_Get_Log_Nhat_Ky_Dang_Nhap_By_ID", p_iID);

        //        if (v_dt.Rows.Count > 0)
        //        {
        //            v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Dang_Nhap>(v_dt.Rows[0]);
        //        }
        //    }

        //    catch (Exception)
        //    {
        //        throw;
        //    }

        //    finally
        //    {
        //        v_dt.Dispose();
        //    }

        //    return v_objRes;
        //}

        //public long Insert_Log_Nhat_Ky_Dang_Nhap(CLog_Nhat_Ky_Dang_Nhap p_objData)
        //{
        //    long v_iRes = CConst.INT_VALUE_NULL;

        //    try
        //    {
        //        v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "sp_ins_Log_Nhat_Ky_Dang_Nhap",
        //            p_objData.Ma_Dang_Nhap, p_objData.IP, p_objData.User_Agent, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
        //    }

        //    catch (Exception)
        //    {
        //        throw;
        //    }

        //    return v_iRes;
        //}

        //public void Update_Log_Nhat_Ky_Dang_Nhap(CLog_Nhat_Ky_Dang_Nhap p_objData)
        //{
        //    try
        //    {
        //        CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "sp_upd_Log_Nhat_Ky_Dang_Nhap", p_objData.Auto_ID,
        //            p_objData.Ma_Dang_Nhap, p_objData.IP, p_objData.User_Agent, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
        //    }

        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}

        //public void Delete_Log_Nhat_Ky_Dang_Nhap(long p_iAuto_ID, string p_strLast_Updated_By, string p_strLast_Updated_By_Function)
        //{
        //    try
        //    {
        //        CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "sp_del_Log_Nhat_Ky_Dang_Nhap", p_iAuto_ID, p_strLast_Updated_By, p_strLast_Updated_By_Function);
        //    }

        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}

        //public long FCommon_Sys_sp_ins_Log_Nhat_Ky_Dang_Nhap(CLog_Nhat_Ky_Dang_Nhap p_objData)
        //{
        //    long v_iRes = CConst.INT_VALUE_NULL;

        //    try
        //    {
        //        v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FCommon_Sys_sp_ins_Log_Nhat_Ky_Dang_Nhap",
        //            p_objData.Ma_Dang_Nhap, p_objData.IP, p_objData.User_Agent, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
        //    }

        //    catch (Exception)
        //    {
        //        throw;
        //    }

        //    return v_iRes;
        //}

        public List<CLog_Nhat_Ky_Dang_Nhap> F1006_sp_sel_List_Log_Nhat_Ky_Dang_Nhap_By_User(string p_strUser)
        {
            List<CLog_Nhat_Ky_Dang_Nhap> v_arrRes = new List<CLog_Nhat_Ky_Dang_Nhap>();
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "F1006_sp_sel_List_Log_Nhat_Ky_Dang_Nhap_By_User", p_strUser);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_Nhat_Ky_Dang_Nhap v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Dang_Nhap>(v_row);
                    v_arrRes.Add(v_objRes);
                }
            }

            catch (Exception)
            {
                throw;
            }

            finally
            {
                v_dt.Dispose();
            }

            return v_arrRes;
        }

		public List<CLog_Nhat_Ky_Dang_Nhap> F1009_sp_sel_List_Nhat_Ky_Dang_Nhap_Ca_Nhan(DateTime? p_dtmFrom, DateTime? p_dtmTo, string p_strUser)
		{
			List<CLog_Nhat_Ky_Dang_Nhap> v_arrRes = new List<CLog_Nhat_Ky_Dang_Nhap>();
			DataTable v_dt = new DataTable();

			try
			{
				p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
				p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "F1009_sp_sel_List_Nhat_Ky_Dang_Nhap_Ca_Nhan", p_dtmFrom, p_dtmTo, p_strUser);

				foreach (DataRow v_row in v_dt.Rows)
				{
					CLog_Nhat_Ky_Dang_Nhap v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Dang_Nhap>(v_row);
					v_arrRes.Add(v_objRes);
				}
			}

			catch (Exception)
			{
				throw;
			}

			finally
			{
				v_dt.Dispose();
			}

			return v_arrRes;
		}


		public List<CLog_Nhat_Ky_Dang_Nhap> F1010_sp_sel_List_Nhat_Ky_Dang_Nhap_All(DateTime? p_dtmFrom, DateTime? p_dtmTo)
		{
			List<CLog_Nhat_Ky_Dang_Nhap> v_arrRes = new List<CLog_Nhat_Ky_Dang_Nhap>();
			DataTable v_dt = new DataTable();

			try
			{
				p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
				p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "F1010_sp_sel_List_Nhat_Ky_Dang_Nhap_All", p_dtmFrom, p_dtmTo);

				foreach (DataRow v_row in v_dt.Rows)
				{
					CLog_Nhat_Ky_Dang_Nhap v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Dang_Nhap>(v_row);
					v_arrRes.Add(v_objRes);
				}
			}

			catch (Exception)
			{
				throw;
			}

			finally
			{
				v_dt.Dispose();
			}

			return v_arrRes;
		}

	}
}
