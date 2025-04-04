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
    public class CLog_Nhat_Ky_Truy_Cap_Chuc_Nang_Controller
    {
        public List<CLog_Nhat_Ky_Truy_Cap_Chuc_Nang> FQ_424_NKTCCN_sp_sel_List_By_Created(DateTime? p_dtmFrom, DateTime? p_dtmTo)
        {
            List<CLog_Nhat_Ky_Truy_Cap_Chuc_Nang> v_arrRes = new List<CLog_Nhat_Ky_Truy_Cap_Chuc_Nang>();
            DataTable v_dt = new DataTable();

            try
            {
                p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
                p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_424_NKTCCN_sp_sel_List_By_Created", p_dtmFrom, p_dtmTo);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_Nhat_Ky_Truy_Cap_Chuc_Nang v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Truy_Cap_Chuc_Nang>(v_row);
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

        public CLog_Nhat_Ky_Truy_Cap_Chuc_Nang FQ_424_NKTCCN_sp_sel_Get_By_ID(long p_iID)
        {
            CLog_Nhat_Ky_Truy_Cap_Chuc_Nang v_objRes = null;
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_424_NKTCCN_sp_sel_Get_By_ID", p_iID);

                if (v_dt.Rows.Count > 0)
                {
                    v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Truy_Cap_Chuc_Nang>(v_dt.Rows[0]);
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

        public long FQ_424_NKTCCN_sp_ins_Insert(CLog_Nhat_Ky_Truy_Cap_Chuc_Nang p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_424_NKTCCN_sp_ins_Insert",
                    p_objData.Ma_Dang_Nhap, p_objData.Ma_Chuc_Nang, p_objData.Ten_Chuc_Nang, p_objData.Created_By));
            }

            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public void FQ_424_NKTCCN_sp_del_Delete_By_ID(long p_iAuto_ID, string p_strLast_Updated_By, string p_strLast_Updated_By_Function)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_424_NKTCCN_sp_del_Delete_By_ID", p_iAuto_ID, p_strLast_Updated_By, p_strLast_Updated_By_Function);
            }

            catch (Exception)
            {
                throw;
            }
        }

        public List<CLog_Nhat_Ky_Truy_Cap_Chuc_Nang> F1006_sp_sel_List_Log_Nhat_Ky_Truy_Cap_Chuc_Nang_By_User(string p_strMa_Dang_Nhap)
        {
            List<CLog_Nhat_Ky_Truy_Cap_Chuc_Nang> v_arrRes = new List<CLog_Nhat_Ky_Truy_Cap_Chuc_Nang>();
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "F1006_sp_sel_List_Log_Nhat_Ky_Truy_Cap_Chuc_Nang_By_User", p_strMa_Dang_Nhap);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_Nhat_Ky_Truy_Cap_Chuc_Nang v_objRes = CUtility.Map_Row_To_Entity<CLog_Nhat_Ky_Truy_Cap_Chuc_Nang>(v_row);
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
