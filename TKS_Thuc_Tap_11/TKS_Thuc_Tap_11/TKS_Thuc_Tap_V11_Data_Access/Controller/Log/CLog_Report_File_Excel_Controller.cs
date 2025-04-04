using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.DataLayer;
using TKS_Thuc_Tap_V11_Data_Access.Entity.Log;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Controller.Log
{
	public class CLog_Report_File_Excel_Controller
	{
        public List<CLog_Report_File_Excel> FQ_427_RFE_sp_sel_List_By_Created(DateTime? p_dtmFrom, DateTime? p_dtmTo)
        {
            List<CLog_Report_File_Excel> v_arrRes = new List<CLog_Report_File_Excel>();
            DataTable v_dt = new DataTable();

            try
            {
                p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
                p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_427_RFE_sp_sel_List_By_Created",p_dtmFrom, p_dtmTo);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_Report_File_Excel v_objRes = CUtility.Map_Row_To_Entity<CLog_Report_File_Excel>(v_row);
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

        public CLog_Report_File_Excel FQ_427_RFE_sp_sel_Get_By_ID(long p_iID)
        {
            CLog_Report_File_Excel v_objRes = null;
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_427_RFE_sp_sel_Get_By_ID", p_iID);

                if (v_dt.Rows.Count > 0)
                {
                    v_objRes = CUtility.Map_Row_To_Entity<CLog_Report_File_Excel>(v_dt.Rows[0]);
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

        public long FQ_427_RFE_sp_ins_Insert(CLog_Report_File_Excel p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_427_RFE_sp_ins_Insert",
                    p_objData.Chu_Hang_ID, p_objData.Report_File_Type_ID, p_objData.Ten_File, p_objData.File_URL,
                    p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
            }

            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public long FQ_427_RFE_sp_ins_Insert(SqlConnection p_conn, SqlTransaction p_trans, CLog_Report_File_Excel p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_427_RFE_sp_ins_Insert",
                    p_objData.Chu_Hang_ID, p_objData.Report_File_Type_ID, p_objData.Ten_File, p_objData.File_URL,
                    p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
            }

            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public void FQ_427_RFE_sp_upd_Update(CLog_Report_File_Excel p_objData)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_427_RFE_sp_upd_Update", p_objData.Auto_ID,
                    p_objData.Chu_Hang_ID, p_objData.Report_File_Type_ID, p_objData.Ten_File, p_objData.File_URL,
                    p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
            }

            catch (Exception)
            {
                throw;
            }
        }

        public void FQ_427_RFE_sp_upd_Update(SqlConnection p_conn, SqlTransaction p_trans, CLog_Report_File_Excel p_objData)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_427_RFE_sp_upd_Update", p_objData.Auto_ID,
                    p_objData.Chu_Hang_ID, p_objData.Report_File_Type_ID, p_objData.Ten_File, p_objData.File_URL,
                    p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
            }

            catch (Exception)
            {
                throw;
            }
        }

        public void FQ_427_RFE_sp_del_Delete_By_ID(long p_iAuto_ID, string p_strLast_Updated_By, string p_strLast_Updated_By_Function)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_427_RFE_sp_del_Delete_By_ID", p_iAuto_ID, p_strLast_Updated_By, p_strLast_Updated_By_Function);
            }

            catch (Exception)
            {
                throw;
            }
        }

        public List<CLog_Report_File_Excel> FNLVJLA005_List_Log_Report_File_Excel_Export_By_Function_Code(string p_strFunction_Code, int p_iType_ID)
		{
			List<CLog_Report_File_Excel> v_arrRes = new List<CLog_Report_File_Excel>();
			DataTable v_dt = new DataTable();

			try
			{
				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FINLVJLA005_sp_sel_List_Log_Report_File_Excel_Export_By_Function_Code", p_strFunction_Code, p_iType_ID);

				foreach (DataRow v_row in v_dt.Rows)
				{
					CLog_Report_File_Excel v_objRes = CUtility.Map_Row_To_Entity<CLog_Report_File_Excel>(v_row);
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
       

        public List<CLog_Report_File_Excel> FI048_List_Log_Report_File_Excel_Export_By_Function_Code(string p_strFunction_Code, int p_iType_ID)
        {
            List<CLog_Report_File_Excel> v_arrRes = new List<CLog_Report_File_Excel>();
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FI048_sp_sel_List_Log_Report_File_Excel_Export_By_Function_Code", p_strFunction_Code, p_iType_ID);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CLog_Report_File_Excel v_objRes = CUtility.Map_Row_To_Entity<CLog_Report_File_Excel>(v_row);
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
