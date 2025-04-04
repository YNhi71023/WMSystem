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
	public class CLog_Import_Excel_Controller
	{
		public List<CLog_Import_Excel> FQ_422_IE_sp_sel_List_By_Created(DateTime? p_dtmFrom, DateTime? p_dtmTo)
		{
			List<CLog_Import_Excel> v_arrRes = new List<CLog_Import_Excel>();
			DataTable v_dt = new DataTable();

			try
			{
				p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
				p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_422_IE_sp_sel_List_By_Created", p_dtmFrom, p_dtmTo);

				foreach (DataRow v_row in v_dt.Rows)
				{
					CLog_Import_Excel v_objRes = CUtility.Map_Row_To_Entity<CLog_Import_Excel>(v_row);
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

		public CLog_Import_Excel FQ_422_IE_sp_sel_Get_By_ID(long p_iID)
		{
			CLog_Import_Excel v_objRes = null;
			DataTable v_dt = new DataTable();

			try
			{
				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_422_IE_sp_sel_Get_By_ID", p_iID);

				if (v_dt.Rows.Count > 0)
				{
					v_objRes = CUtility.Map_Row_To_Entity<CLog_Import_Excel>(v_dt.Rows[0]);
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

		public long FQ_422_IE_sp_ins_Insert(CLog_Import_Excel p_objData)
		{
			long v_iRes = CConst.INT_VALUE_NULL;

			try
			{
				v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_422_IE_sp_ins_Insert",
					p_objData.Ma_Chuc_Nang, p_objData.Ten_Chuc_Nang, p_objData.Link_URL, p_objData.Trang_Thai_ID, p_objData.Ghi_Chu, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
			}

			catch (Exception)
			{
				throw;
			}

			return v_iRes;
		}

		public long FQ_422_IE_sp_ins_Insert(SqlConnection p_conn, SqlTransaction p_trans, CLog_Import_Excel p_objData)
		{
			long v_iRes = CConst.INT_VALUE_NULL;

			try
			{
				v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_422_IE_sp_ins_Insert",
					p_objData.Ma_Chuc_Nang, p_objData.Ten_Chuc_Nang, p_objData.Link_URL, p_objData.Trang_Thai_ID, p_objData.Ghi_Chu, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
			}

			catch (Exception)
			{
				throw;
			}

			return v_iRes;
		}

		public void FQ_422_IE_sp_upd_Update(CLog_Import_Excel p_objData)
		{
			try
			{
				CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_422_IE_sp_upd_Update", p_objData.Auto_ID,
					p_objData.Ma_Chuc_Nang, p_objData.Ten_Chuc_Nang, p_objData.Link_URL, p_objData.Trang_Thai_ID, p_objData.Ghi_Chu,
					p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
			}

			catch (Exception)
			{
				throw;
			}
		}

		public void FQ_422_IE_sp_upd_Update(SqlConnection p_conn, SqlTransaction p_trans, CLog_Import_Excel p_objData)
		{
			try
			{
				CSqlHelper.ExecuteNonquery(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_422_IE_sp_upd_Update", p_objData.Auto_ID,
					p_objData.Ma_Chuc_Nang, p_objData.Ten_Chuc_Nang, p_objData.Link_URL, p_objData.Trang_Thai_ID, p_objData.Ghi_Chu,
					p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
			}

			catch (Exception)
			{
				throw;
			}
		}

		public void FQ_422_IE_sp_del_Delete_By_ID(long p_iAuto_ID, string p_strLast_Updated_By, string p_strLast_Updated_By_Function)
		{
			try
			{
				CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_422_IE_sp_del_Delete_By_ID", p_iAuto_ID, p_strLast_Updated_By, p_strLast_Updated_By_Function);
			}

			catch (Exception)
			{
				throw;
			}
		}

		//public List<CLog_Import_Excel> List_Log_Import_Excel()
		//{
		//	List<CLog_Import_Excel> v_arrRes = new List<CLog_Import_Excel>();
		//	DataTable v_dt = new DataTable();

		//	try
		//	{
		//		CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "sp_sel_List_Log_Import_Excel");

		//		foreach (DataRow v_row in v_dt.Rows)
		//		{
		//			CLog_Import_Excel v_objRes = CUtility.Map_Row_To_Entity<CLog_Import_Excel>(v_row);
		//			v_arrRes.Add(v_objRes);
		//		}
		//	}

		//	catch (Exception)
		//	{
		//		throw;
		//	}

		//	finally
		//	{
		//		v_dt.Dispose();
		//	}

		//	return v_arrRes;
		//}

		//public CLog_Import_Excel Get_Log_Import_Excel_By_ID(long p_iID)
		//{
		//	CLog_Import_Excel v_objRes = null;
		//	DataTable v_dt = new DataTable();

		//	try
		//	{
		//		CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "sp_sel_Get_Log_Import_Excel_By_ID", p_iID);

		//		if (v_dt.Rows.Count > 0)
		//		{
		//			v_objRes = CUtility.Map_Row_To_Entity<CLog_Import_Excel>(v_dt.Rows[0]);
		//		}
		//	}

		//	catch (Exception)
		//	{
		//		throw;
		//	}

		//	finally
		//	{
		//		v_dt.Dispose();
		//	}

		//	return v_objRes;
		//}

		//public long Insert_Log_Import_Excel(CLog_Import_Excel p_objData)
		//{
		//	long v_iRes = CConst.INT_VALUE_NULL;

		//	try
		//	{
		//		v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "sp_ins_Log_Import_Excel",
		//			p_objData.Ma_Chuc_Nang, p_objData.Ten_Chuc_Nang, p_objData.Link_URL, p_objData.Trang_Thai_ID, p_objData.Ghi_Chu, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
		//	}

		//	catch (Exception)
		//	{
		//		throw;
		//	}

		//	return v_iRes;
		//}

		//public void Update_Log_Import_Excel(CLog_Import_Excel p_objData)
		//{
		//	try
		//	{
		//		CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "sp_upd_Log_Import_Excel", p_objData.Auto_ID,
		//			p_objData.Ma_Chuc_Nang, p_objData.Ten_Chuc_Nang, p_objData.Link_URL, p_objData.Trang_Thai_ID, p_objData.Ghi_Chu, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
		//	}

		//	catch (Exception)
		//	{
		//		throw;
		//	}
		//}

		//public void Delete_Log_Import_Excel(long p_iAuto_ID, string p_strLast_Updated_By, string p_strLast_Updated_By_Function)
		//{
		//	try
		//	{
		//		CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "sp_del_Log_Import_Excel", p_iAuto_ID, p_strLast_Updated_By, p_strLast_Updated_By_Function);
		//	}

		//	catch (Exception)
		//	{
		//		throw;
		//	}
		//}

		//public long FCommon_Sys_sp_ins_Log_Import_Excel(CLog_Import_Excel p_objData)
		//{
		//	long v_iRes = CConst.INT_VALUE_NULL;

		//	try
		//	{
		//		v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FCommon_Sys_sp_ins_Log_Import_Excel",
		//			p_objData.Ma_Chuc_Nang, p_objData.Ten_Chuc_Nang, p_objData.Link_URL, p_objData.Trang_Thai_ID, p_objData.Ghi_Chu, p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
		//	}

		//	catch (Exception)
		//	{
		//		throw;
		//	}

		//	return v_iRes;
		//}

		public List<CLog_Import_Excel> F1029_sp_sel_List_Nhat_Ky_Import_Excel(DateTime? p_dtmFrom, DateTime? p_dtmTo)
		{
			List<CLog_Import_Excel> v_arrRes = new List<CLog_Import_Excel>();
			DataTable v_dt = new DataTable();

			try
			{
				p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
				p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

				CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "F1029_sp_sel_List_Nhat_Ky_Import_Excel", p_dtmFrom, p_dtmTo);

				foreach (DataRow v_row in v_dt.Rows)
				{
					CLog_Import_Excel v_objRes = CUtility.Map_Row_To_Entity<CLog_Import_Excel>(v_row);
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
