using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TKS_Thuc_Tap_V11_Data_Access.DataLayer;
using TKS_Thuc_Tap_V11_Data_Access.Entity.DM;
using TKS_Thuc_Tap_V11_Data_Access.Utility;

namespace TKS_Thuc_Tap_V11_Data_Access.Controller.DM
{
    public class CDM_Phieu_Nhap_Kho_Controller
    {

        public List<CDM_Phieu_Nhap_Kho> FQ_719_NKRD_sp_sel_List_By_Created(DateTime? p_dtmFrom, DateTime? p_dtmTo)
        {
            List<CDM_Phieu_Nhap_Kho> v_arrRes = new List<CDM_Phieu_Nhap_Kho>();
            DataTable v_dt = new DataTable();

            try
            {
                p_dtmFrom = CUtility_Date.Convert_To_Dau_Ngay(p_dtmFrom);
                p_dtmTo = CUtility_Date.Convert_To_Cuoi_Ngay(p_dtmTo);

                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_719_NKRD_sp_sel_List_By_Created", p_dtmFrom, p_dtmTo);

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CDM_Phieu_Nhap_Kho v_objRes = CUtility.Map_Row_To_Entity<CDM_Phieu_Nhap_Kho>(v_row);
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

        public List<CDM_Phieu_Nhap_Kho> FQ_719_NKRD_sp_sel_List_For_Cache()
        {
            List<CDM_Phieu_Nhap_Kho> v_arrRes = new List<CDM_Phieu_Nhap_Kho>();
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_719_NKRD_sp_sel_List_For_Cache");

                foreach (DataRow v_row in v_dt.Rows)
                {
                    CDM_Phieu_Nhap_Kho v_objRes = CUtility.Map_Row_To_Entity<CDM_Phieu_Nhap_Kho>(v_row);
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
        //public List<CDM_Phieu_Nhap_Kho> FQ_719_NKRD_sp_sel_Get_By_ID(long p_iNhapKhoID)
        //{
        //    List<CDM_Phieu_Nhap_Kho> v_lstRes = new();
        //    DataTable v_dt = new();

        //    try
        //    {
        //        CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_719_NKRD_sp_sel_Get_By_ID", p_iNhapKhoID);

        //        foreach (DataRow row in v_dt.Rows)
        //        {
        //            var obj = CUtility.Map_Row_To_Entity<CDM_Phieu_Nhap_Kho>(row);
        //            v_lstRes.Add(obj);
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

        //    return v_lstRes;
        //}

        public CDM_Phieu_Nhap_Kho FQ_719_NKRD_sp_sel_Get_By_ID(long p_iID)
        {
            CDM_Phieu_Nhap_Kho v_objRes = null;
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "FQ_719_NKRD_sp_sel_Get_By_ID", p_iID);

                if (v_dt.Rows.Count > 0)
                {
                    v_objRes = CUtility.Map_Row_To_Entity<CDM_Phieu_Nhap_Kho>(v_dt.Rows[0]);
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
        public List<CDM_Phieu_Nhap_Kho> F7001_sp_sel_List_By_Nhap_Kho_ID(long p_iID)
        {
            List<CDM_Phieu_Nhap_Kho> v_lstRes = new();
            DataTable v_dt = new();

            try
            {
                CSqlHelper.FillDataTable(CConfig.TKS_Thuc_Tap_V11_Conn_String, v_dt, "F7001_sp_sel_List_By_Nhap_Kho_ID", p_iID);

                foreach (DataRow row in v_dt.Rows)
                {
                    var obj = CUtility.Map_Row_To_Entity<CDM_Phieu_Nhap_Kho>(row);
                    v_lstRes.Add(obj);
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

            return v_lstRes;
        }

        public CDM_Phieu_Nhap_Kho F7001_sp_sel_List_By_NhapKho_And_SanPham (long p_iNhapKhoID, long p_iSanPhamID)
        {
            CDM_Phieu_Nhap_Kho v_objRes = null;
            DataTable v_dt = new DataTable();

            try
            {
                CSqlHelper.FillDataTable(
                    CConfig.TKS_Thuc_Tap_V11_Conn_String,
                    v_dt,
                    "F7001_sp_sel_List_By_NhapKho_And_SanPham",
                    p_iNhapKhoID,
                    p_iSanPhamID
                );

                if (v_dt.Rows.Count > 0)
                {
                    v_objRes = CUtility.Map_Row_To_Entity<CDM_Phieu_Nhap_Kho>(v_dt.Rows[0]);
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

        public long FQ_719_NKRD_sp_ins_Insert(CDM_Phieu_Nhap_Kho p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_719_NKRD_sp_ins_Insert",
                    p_objData.Nhap_Kho_ID, p_objData.San_Pham_ID, p_objData.SL_Nhap, p_objData.Don_Gia_Nhap,
                    p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
            }

            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public long FQ_719_NKRD_sp_ins_Insert(SqlConnection p_conn, SqlTransaction p_trans, CDM_Phieu_Nhap_Kho p_objData)
        {
            long v_iRes = CConst.INT_VALUE_NULL;

            try
            {
                v_iRes = Convert.ToInt64(CSqlHelper.ExecuteScalar(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_719_NKRD_sp_ins_Insert",
                 p_objData.Nhap_Kho_ID, p_objData.San_Pham_ID, p_objData.SL_Nhap, p_objData.Don_Gia_Nhap,
                    p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function));
            }

            catch (Exception)
            {
                throw;
            }

            return v_iRes;
        }

        public void FQ_719_NKRD_sp_upd_Update(CDM_Phieu_Nhap_Kho p_objData)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_719_NKRD_sp_upd_Update", p_objData.Auto_ID,
                   p_objData.Nhap_Kho_ID, p_objData.San_Pham_ID, p_objData.SL_Nhap, p_objData.Don_Gia_Nhap,
                    p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
            }

            catch (Exception)
            {
                throw;
            }
        }

        public void FQ_719_NKRD_sp_upd_Update(SqlConnection p_conn, SqlTransaction p_trans, CDM_Phieu_Nhap_Kho p_objData)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(p_conn, p_trans, CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_719_NKRD_sp_upd_Update", p_objData.Auto_ID,
                     p_objData.Nhap_Kho_ID, p_objData.San_Pham_ID, p_objData.SL_Nhap, p_objData.Don_Gia_Nhap,
                    p_objData.Last_Updated_By, p_objData.Last_Updated_By_Function);
            }

            catch (Exception)
            {
                throw;
            }
        }

        public void FQ_719_NKRD_sp_del_Delete_By_ID(long p_iAuto_ID, string p_strLast_Updated_By, string p_strLast_Updated_By_Function)
        {
            try
            {
                CSqlHelper.ExecuteNonquery(CConfig.TKS_Thuc_Tap_V11_Conn_String, "FQ_719_NKRD_sp_del_Delete_By_ID", p_iAuto_ID, p_strLast_Updated_By, p_strLast_Updated_By_Function);
            }

            catch (Exception)
            {
                throw;
            }
        }

    }
}
