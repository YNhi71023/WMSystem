USE [TKS_Thuc_Tap_V11]
GO
/****** Object:  UserDefinedFunction [dbo].[fnConvert_Ngay_To_NULL]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnConvert_Ngay_To_NULL] (
	@Date datetime
)
RETURNS datetime
AS
BEGIN
	if (convert(varchar, @Date, 105) = '01-01-1900' or convert(varchar, @Date, 105) = '30-12-1899' or convert(varchar, @Date, 105) = '31-12-1899')
		return null
	
	return @Date
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnConvert_Number_To_Text]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnConvert_Number_To_Text] (
	@Number float
)
RETURNS nvarchar(200)
AS
BEGIN
	if (@Number = 0)
		return '-'

	declare @Is_Su_Dung_Thap_Phan int = 0

	if (Round(@Number, 1) <> Round(@Number, 2))
		set @Is_Su_Dung_Thap_Phan = 1

	if (Round(@Number, 2) <> Round(@Number, 4))
		set @Is_Su_Dung_Thap_Phan = 2

	declare @Res nvarchar(200)
	
	if @Is_Su_Dung_Thap_Phan = 0
		set @Res = REPLACE(CONVERT(varchar(20), (CAST(isnull(@Number, 0) AS money)), 1), '.00', '')
	else
		set @Res = CONVERT(varchar(20), (CAST(isnull(@Number, 0) AS money)), @Is_Su_Dung_Thap_Phan)

	return @Res

END
GO
/****** Object:  UserDefinedFunction [dbo].[fnConvert_To_Cuoi_Ngay]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnConvert_To_Cuoi_Ngay] (
	@Date datetime
)
RETURNS DateTime
AS
BEGIN
	return convert(datetime, convert(varchar, @Date , 106) + ' 23:59:59')
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnConvert_To_Dau_Ngay]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnConvert_To_Dau_Ngay] (
	@Date datetime
)
RETURNS DateTime
AS
BEGIN
	return convert(datetime, convert(varchar, @Date, 105), 105)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnFix_SL_Chan_From_All_Special]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnFix_SL_Chan_From_All_Special] (
	@SL_All_Special decimal(22, 5),
	@SL_Cai_1_Thung decimal(22, 5)
)
RETURNS float
AS
BEGIN
	return dbo.fnFix_So_Kien_From_All_Special(@SL_All_Special, @SL_Cai_1_Thung) * @SL_Cai_1_Thung
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnFix_SL_Le_From_All_Special]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnFix_SL_Le_From_All_Special] (
	@SL_All_Special decimal(22, 5),
	@SL_Cai_1_Thung decimal(22, 5)
)
RETURNS float
AS
BEGIN
	return @SL_All_Special - dbo.fnFix_SL_Chan_From_All_Special(@SL_All_Special, @SL_Cai_1_Thung)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnFix_So_Kien_From_All_Special]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnFix_So_Kien_From_All_Special] (
	@SL_All_Special decimal(22, 5),
	@SL_Cai_1_Thung decimal(22, 5)
)
RETURNS float
AS
BEGIN
	if (@SL_All_Special < 0)
		return 0 - FLOOR(abs(ISNULL(@SL_All_Special , 0)) / @SL_Cai_1_Thung)

	return FLOOR(ISNULL(@SL_All_Special , 0) / @SL_Cai_1_Thung)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnList_Nhom_Thanh_Vien_By_Ma_Dang_Nhap]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [dbo].[fnList_Nhom_Thanh_Vien_By_Ma_Dang_Nhap]
(
	@Ma_Dang_Nhap nvarchar(200)
)
RETURNS nvarchar(2000)
AS
BEGIN	
	   declare @Res nvarchar(2000)
       set @Res = ''
       declare @Ten_Nhom_Thanh_Vien nvarchar(200)
 
       declare Nhom_Thanh_Vien_Cursor CURSOR FOR
       SELECT Ten_Nhom_Thanh_Vien
       FROM view_Sys_Nhom_Thanh_Vien_User with (nolock) 
	   where 
			Ma_Dang_Nhap = @Ma_Dang_Nhap
       order by Ten_Nhom_Thanh_Vien ASC
 
       OPEN Nhom_Thanh_Vien_Cursor
       FETCH NEXT FROM Nhom_Thanh_Vien_Cursor
       INTO @Ten_Nhom_Thanh_Vien
 
       WHILE @@FETCH_STATUS = 0
       BEGIN 
              if (isnull(@Ten_Nhom_Thanh_Vien, '') <> '')
              BEGIN
					if (@Res = '')
						set @Res = @Ten_Nhom_Thanh_Vien
					else
						set @Res = @Res + ', ' + @Ten_Nhom_Thanh_Vien
              END
 
              FETCH NEXT FROM Nhom_Thanh_Vien_Cursor
			  INTO @Ten_Nhom_Thanh_Vien
       END
       CLOSE Nhom_Thanh_Vien_Cursor
       DEALLOCATE Nhom_Thanh_Vien_Cursor
 
       return @Res	
END
GO
/****** Object:  UserDefinedFunction [dbo].[fnValue_Qui_Cach_Thung]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnValue_Qui_Cach_Thung] (
	@So_Kien decimal(22, 5),
	@SL_Chan decimal(22, 5),
	@SL_Cai_1_Thung decimal(22, 5)
)
RETURNS float
AS
BEGIN
	declare @Qui_Cach decimal(22, 5) = 0

	if(isnull(@So_Kien, 0) > 0)
	begin
		set @Qui_Cach = isnull(@SL_Chan, 0) / isnull(@So_Kien, 0)
	end
	else
	begin
		set @Qui_Cach = @SL_Cai_1_Thung
	end

	if(isnull(@Qui_Cach, 0) = 0)
		set @Qui_Cach = 1

	return @Qui_Cach
END
GO
/****** Object:  Table [dbo].[tbl_DM_San_Pham]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_DM_San_Pham](
	[Auto_ID] [bigint] NULL,
	[Ma_San_Pham] [nvarchar](50) NULL,
	[Ten_San_Pham] [nvarchar](200) NULL,
	[Loai_San_Pham_ID] [bigint] NULL,
	[Don_Vi_Tinh_ID] [bigint] NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_DM_San_Pham]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_DM_San_Pham]
AS
SELECT A.Auto_ID, A.Ma_San_Pham, A.Ten_San_Pham, A.Loai_San_Pham_ID, A.Don_Vi_Tinh_ID, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_DM_San_Pham AS A
WHERE
	(deleted = 0)


GO
/****** Object:  Table [dbo].[tbl_Sys_API_Source_Function]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_API_Source_Function](
	[Auto_ID] [bigint] NOT NULL,
	[API_Source_ID] [bigint] NULL,
	[Ma_API_Function] [nvarchar](50) NULL,
	[Ten_API_Function] [nvarchar](200) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_API_Source_Function] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_API_Source_Function]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_API_Source_Function]
AS
SELECT A.Auto_ID, A.API_Source_ID, A.Ma_API_Function, A.Ten_API_Function, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_API_Source_Function AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Log_Nhat_Ky_Dang_Nhap]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Log_Nhat_Ky_Dang_Nhap](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_Dang_Nhap] [nvarchar](50) NULL,
	[IP] [nvarchar](50) NULL,
	[User_Agent] [nvarchar](500) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Log_Nhat_Ky_Dang_Nhap] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Log_Nhat_Ky_Dang_Nhap]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Log_Nhat_Ky_Dang_Nhap]
AS
SELECT A.Auto_ID, A.Ma_Dang_Nhap, A.IP, A.User_Agent, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Log_Nhat_Ky_Dang_Nhap AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_XNK_Nhap_Kho]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_XNK_Nhap_Kho](
	[Auto_ID] [bigint] NULL,
	[So_Phieu_Nhap_Kho] [nvarchar](50) NULL,
	[Kho_ID] [bigint] NULL,
	[NCC_ID] [bigint] NULL,
	[Ngay_Nhap_Kho] [datetime] NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_XNK_Nhap_Kho]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_XNK_Nhap_Kho]
AS
SELECT A.Auto_ID, A.So_Phieu_Nhap_Kho, A.Kho_ID, A.NCC_ID, A.Ngay_Nhap_Kho, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_XNK_Nhap_Kho AS A
WHERE
	(deleted = 0)


GO
/****** Object:  Table [dbo].[tbl_Sys_Filter_Date_Default]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Filter_Date_Default](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_Chuc_Nang] [nvarchar](50) NULL,
	[Duration_Days_From] [decimal](22, 5) NULL,
	[Duration_Days_To] [decimal](22, 5) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Filter_Date_Default] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Filter_Date_Default]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Filter_Date_Default]
AS
SELECT A.Auto_ID, A.Ma_Chuc_Nang, A.Duration_Days_From, A.Duration_Days_To, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Filter_Date_Default AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Daily_Schedule_Job]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Daily_Schedule_Job](
	[Auto_ID] [bigint] NOT NULL,
	[Chu_Hang_ID] [bigint] NULL,
	[Ngay_Gio_Xu_Ly] [datetime] NULL,
	[Schedule_Job_ID] [int] NULL,
	[Email_Nhan] [nvarchar](2000) NULL,
	[Trang_Thai_ID] [int] NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Daily_Schedule_Job] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_DM_Chu_Hang]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_DM_Chu_Hang](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_Chu_Hang] [nvarchar](50) NULL,
	[Ten_Viet_Tat] [nvarchar](200) NULL,
	[Ten_Chu_Hang] [nvarchar](200) NULL,
	[Dia_Chi] [nvarchar](200) NULL,
	[Dien_Thoai] [nvarchar](200) NULL,
	[Email] [nvarchar](200) NULL,
	[MST] [nvarchar](50) NULL,
	[Header_Title] [nvarchar](50) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[Image_URL_Thumb] [nvarchar](200) NULL,
	[Image_URL] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_DM_Chu_Hang] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_DM_Chu_Hang]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[view_DM_Chu_Hang]
AS
SELECT A.Auto_ID, A.Ma_Chu_Hang, A.Ten_Viet_Tat, A.Ten_Chu_Hang, A.Dia_Chi, A.Dien_Thoai, A.Email, A.MST, A.Header_Title, A.Ghi_Chu,A.Image_URL_Thumb, A.Image_URL, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, 
                  A.Last_Updated_By_Function
FROM     dbo.tbl_DM_Chu_Hang AS A 
WHERE  (A.deleted = 0)
GO
/****** Object:  View [dbo].[view_Sys_Daily_Schedule_Job]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[view_Sys_Daily_Schedule_Job]
AS
SELECT        A.Auto_ID, A.Chu_Hang_ID, A.Ngay_Gio_Xu_Ly, A.Schedule_Job_ID, A.Email_Nhan, A.Trang_Thai_ID, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, 
                         A.Last_Updated_By_Function, B.Ma_Chu_Hang, B.Ten_Viet_Tat, B.Ten_Chu_Hang
FROM            dbo.tbl_Sys_Daily_Schedule_Job AS A LEFT OUTER JOIN
                         dbo.view_DM_Chu_Hang AS B ON A.Chu_Hang_ID = B.Auto_ID
WHERE        (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Log_Nhat_Ky_Truy_Cap_Chuc_Nang]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Log_Nhat_Ky_Truy_Cap_Chuc_Nang](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_Dang_Nhap] [nvarchar](50) NULL,
	[Ma_Chuc_Nang] [nvarchar](50) NULL,
	[Ten_Chuc_Nang] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Log_Nhat_Ky_Truy_Cap_Chuc_Nang] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Log_Nhat_Ky_Truy_Cap_Chuc_Nang]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Log_Nhat_Ky_Truy_Cap_Chuc_Nang]
AS
SELECT Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, deleted, Created, Created_By, Ma_Dang_Nhap
FROM     dbo.tbl_Log_Nhat_Ky_Truy_Cap_Chuc_Nang AS A
WHERE  (deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_XNK_Nhap_Kho_Raw_Data]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_XNK_Nhap_Kho_Raw_Data](
	[Auto_ID] [bigint] NULL,
	[Nhap_Kho_ID] [bigint] NULL,
	[San_Pham_ID] [bigint] NULL,
	[SL_Nhap] [bigint] NULL,
	[Don_Gia_Nhap] [bigint] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_XNK_Nhap_Kho_Raw_Data]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_XNK_Nhap_Kho_Raw_Data]
AS
SELECT A.Auto_ID, A.Nhap_Kho_ID, A.San_Pham_ID, A.SL_Nhap, A.Don_Gia_Nhap, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_XNK_Nhap_Kho_Raw_Data AS A
WHERE
	(deleted = 0)


GO
/****** Object:  Table [dbo].[tbl_Sys_STT_Next]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_STT_Next](
	[Auto_ID] [bigint] NOT NULL,
	[Chu_Hang_ID] [bigint] NULL,
	[Quy_Tac_Phieu] [nvarchar](200) NULL,
	[Type_ID] [int] NULL,
	[Digits] [int] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_STT_Next] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_STT_Next]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[view_Sys_STT_Next]
AS
SELECT        A.Auto_ID, A.Chu_Hang_ID,  A.Quy_Tac_Phieu, A.Type_ID, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, 
                         A.Last_Updated_By_Function, dbo.view_DM_Chu_Hang.Ma_Chu_Hang, dbo.view_DM_Chu_Hang.Ten_Chu_Hang,
						 A.Digits
FROM            dbo.tbl_Sys_STT_Next AS A LEFT OUTER JOIN
                         dbo.view_DM_Chu_Hang ON A.Chu_Hang_ID = dbo.view_DM_Chu_Hang.Auto_ID
WHERE        (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_STT_Next_Detail]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_STT_Next_Detail](
	[Auto_ID] [bigint] NOT NULL,
	[STT_ID] [bigint] NULL,
	[Ngay_Giao_Dich] [datetime] NULL,
	[STT_Current] [int] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_STT_Next_Detail] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_STT_Next_Detail]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[view_Sys_STT_Next_Detail]
AS
SELECT A.Auto_ID, A.STT_ID, A.Ngay_Giao_Dich, A.STT_Current, A.deleted, A.Created, A.Created_By, A.Created_By_Function, 
	A.Last_Updated, A.Last_Updated_By, 
	A.Last_Updated_By_Function, B.Type_ID, B.Chu_Hang_ID, B.Quy_Tac_Phieu, B.Ma_Chu_Hang
FROM   dbo.tbl_Sys_STT_Next_Detail AS A LEFT OUTER JOIN
             dbo.view_Sys_STT_Next AS B ON A.STT_ID = B.Auto_ID
WHERE (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_XNK_Xuat_Kho]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_XNK_Xuat_Kho](
	[Auto_ID] [bigint] NULL,
	[So_Phieu_Xuat_Kho] [nvarchar](50) NULL,
	[Kho_ID] [bigint] NULL,
	[Ngay_Xuat_Kho] [datetime] NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_XNK_Xuat_Kho]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_XNK_Xuat_Kho]
AS
SELECT A.Auto_ID, A.So_Phieu_Xuat_Kho, A.Kho_ID, A.Ngay_Xuat_Kho, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_XNK_Xuat_Kho AS A
WHERE
	(deleted = 0)


GO
/****** Object:  Table [dbo].[tbl_Sys_API_Source_Chu_Hang]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_API_Source_Chu_Hang](
	[Auto_ID] [bigint] NOT NULL,
	[Chu_Hang_ID] [bigint] NULL,
	[API_Source_ID] [bigint] NULL,
	[Trang_Thai_ID] [int] NULL,
	[Ma_Su_Dung] [nvarchar](100) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_API_Source_Chu_Hang] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Sys_API_Source]    Script Date: 19/06/2025 14:38:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_API_Source](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_API_Source] [nvarchar](50) NULL,
	[Ten_API_Source] [nvarchar](200) NULL,
	[Link_API] [nvarchar](200) NULL,
	[User_Name] [nvarchar](200) NULL,
	[Password] [nvarchar](200) NULL,
	[Token_1] [nvarchar](1000) NULL,
	[Token_2] [nvarchar](400) NULL,
	[Client_ID_1] [nvarchar](400) NULL,
	[Client_ID_2] [nvarchar](400) NULL,
	[Url_Folder_Download] [nvarchar](200) NULL,
	[Url_Folder_Upload] [nvarchar](200) NULL,
	[Url_Folder_Download_BAK] [nvarchar](200) NULL,
	[Url_Folder_Upload_BAK] [nvarchar](200) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_API_Source] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_API_Source]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_API_Source]
AS
SELECT A.Auto_ID, A.Ma_API_Source, A.Ten_API_Source, A.Link_API, A.User_Name, A.Password, A.Token_1, A.Token_2, A.Client_ID_1, A.Client_ID_2, A.Ghi_Chu,
A.Url_Folder_Download, A.Url_Folder_Upload, A.Url_Folder_Download_BAK, A.Url_Folder_Upload_BAK,
A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_API_Source AS A
WHERE
	(deleted = 0)
GO
/****** Object:  View [dbo].[view_Sys_API_Source_Chu_Hang]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[view_Sys_API_Source_Chu_Hang]
AS
SELECT A.Auto_ID, A.Chu_Hang_ID, A.API_Source_ID, A.Trang_Thai_ID, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, B.Ma_Chu_Hang, B.Ten_Viet_Tat, 
             B.Ten_Chu_Hang, D.Ma_API_Source, D.Ten_API_Source, A.Ma_Su_Dung
FROM   dbo.tbl_Sys_API_Source_Chu_Hang AS A LEFT OUTER JOIN
             dbo.view_Sys_API_Source AS D ON A.API_Source_ID = D.Auto_ID LEFT OUTER JOIN
             dbo.view_DM_Chu_Hang AS B ON A.Chu_Hang_ID = B.Auto_ID 
WHERE (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Log_Record_Action_History]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Log_Record_Action_History](
	[Auto_ID] [bigint] NOT NULL,
	[Ref_ID] [bigint] NULL,
	[Ten_Hanh_Dong] [nvarchar](30) NULL,
	[Ten_Moi_Truong] [nvarchar](30) NULL,
	[Ma_Chuc_Nang] [nvarchar](20) NULL,
	[Ten_Chuc_Nang] [nvarchar](200) NULL,
	[Noi_Dung_Action] [nvarchar](500) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Log_Record_Action_History] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Log_Record_Action_History]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Log_Record_Action_History]
AS
SELECT Auto_ID, Ref_ID, Ten_Hanh_Dong, Ten_Moi_Truong, Ma_Chuc_Nang, deleted, Created, Created_By, Ten_Chuc_Nang, Noi_Dung_Action
FROM     dbo.tbl_Log_Record_Action_History AS A
WHERE  (deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Log_Import_Excel]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Log_Import_Excel](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_Chuc_Nang] [nvarchar](50) NULL,
	[Ten_Chuc_Nang] [nvarchar](200) NULL,
	[Link_URL] [nvarchar](200) NULL,
	[Trang_Thai_ID] [int] NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Log_Import_Excel] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Log_Import_Excel]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Log_Import_Excel]
AS
SELECT A.Auto_ID, A.Ma_Chuc_Nang, A.Ten_Chuc_Nang, A.Link_URL, A.Trang_Thai_ID, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Log_Import_Excel AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_XNK_Xuat_Kho_Raw_Data]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_XNK_Xuat_Kho_Raw_Data](
	[Auto_ID] [bigint] NULL,
	[Xuat_Kho_ID] [bigint] NULL,
	[San_Pham_ID] [bigint] NULL,
	[SL_Xuat] [bigint] NULL,
	[Don_Gia_Xuat] [bigint] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_XNK_Xuat_Kho_Raw_Data]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_XNK_Xuat_Kho_Raw_Data]
AS
SELECT A.Auto_ID, A.Xuat_Kho_ID, A.San_Pham_ID, A.SL_Xuat, A.Don_Gia_Xuat, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_XNK_Xuat_Kho_Raw_Data AS A
WHERE
	(deleted = 0)


GO
/****** Object:  Table [dbo].[tbl_Log_Report_File_Excel]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Log_Report_File_Excel](
	[Auto_ID] [bigint] NOT NULL,
	[Chu_Hang_ID] [bigint] NULL,
	[Report_File_Type_ID] [int] NULL,
	[Ten_File] [nvarchar](200) NULL,
	[File_URL] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Log_Report_File_Excel] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Log_Report_File_Excel]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[view_Log_Report_File_Excel]
AS
SELECT A.Auto_ID, A.Chu_Hang_ID, A.Report_File_Type_ID, A.Ten_File, A.File_URL, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function,
             dbo.view_DM_Chu_Hang.Ma_Chu_Hang, dbo.view_DM_Chu_Hang.Ten_Viet_Tat, dbo.view_DM_Chu_Hang.Ten_Chu_Hang
FROM   dbo.tbl_Log_Report_File_Excel AS A LEFT OUTER JOIN
             dbo.view_DM_Chu_Hang ON A.Chu_Hang_ID = dbo.view_DM_Chu_Hang.Auto_ID 
WHERE (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_API_Source_Chu_Hang_Function]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_API_Source_Chu_Hang_Function](
	[Auto_ID] [bigint] NOT NULL,
	[API_Source_Chu_Hang_ID] [bigint] NULL,
	[API_Source_Function_ID] [bigint] NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_API_Source_Chu_Hang_Function] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_API_Source_Chu_Hang_Function]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_API_Source_Chu_Hang_Function]
AS
SELECT        A.Auto_ID, A.API_Source_Chu_Hang_ID, A.API_Source_Function_ID, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, 
                         B.Ma_API_Function, B.Ten_API_Function
FROM            dbo.tbl_Sys_API_Source_Chu_Hang_Function AS A INNER JOIN
                         dbo.view_Sys_API_Source_Function B ON A.API_Source_Function_ID = B.Auto_ID
WHERE        (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Thanh_Vien]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Thanh_Vien](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_Dang_Nhap] [nvarchar](50) NULL,
	[Mat_Khau] [nvarchar](50) NULL,
	[Ho_Ten] [nvarchar](100) NULL,
	[Email] [nvarchar](250) NULL,
	[Dien_Thoai] [nvarchar](200) NULL,
	[Hinh_Dai_Dien_URL] [nvarchar](200) NULL,
	[Trang_Thai_ID] [int] NULL,
	[Ten_Nhom_Thanh_Vien_Text] [nvarchar](400) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Thanh_Vien] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Thanh_Vien]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Thanh_Vien]
AS
SELECT A.Auto_ID, A.Ma_Dang_Nhap, A.Mat_Khau, A.Ho_Ten, A.Email, A.Dien_Thoai, A.Hinh_Dai_Dien_URL, A.Trang_Thai_ID, A.Ten_Nhom_Thanh_Vien_Text, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Thanh_Vien AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Column_Width]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Column_Width](
	[Auto_ID] [bigint] NOT NULL,
	[Field_Name] [nvarchar](50) NULL,
	[Do_Rong] [int] NULL,
	[Format_Number] [nvarchar](50) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Column_Width] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Column_Width]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Column_Width]
AS
SELECT A.Auto_ID, A.Field_Name, A.Do_Rong, A.Format_Number, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Column_Width AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Cau_Hinh_Component_App]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Cau_Hinh_Component_App](
	[Auto_ID] [bigint] NOT NULL,
	[Chu_Hang_ID] [bigint] NULL,
	[Component_ID] [int] NULL,
	[Field_Name] [nvarchar](50) NULL,
	[Is_View] [bit] NULL,
	[Notes] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Cau_Hinh_Component_App] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Cau_Hinh_Component_App]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Cau_Hinh_Component_App]
AS
SELECT        A.Auto_ID, A.Chu_Hang_ID, A.Component_ID, A.Field_Name, A.Is_View, A.Notes, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, 
                         dbo.view_DM_Chu_Hang.Ma_Chu_Hang, dbo.view_DM_Chu_Hang.Ten_Viet_Tat
FROM            dbo.tbl_Sys_Cau_Hinh_Component_App AS A LEFT OUTER JOIN
                         dbo.view_DM_Chu_Hang ON A.Chu_Hang_ID = dbo.view_DM_Chu_Hang.Auto_ID
WHERE        (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Chuc_Nang_App]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Chuc_Nang_App](
	[Auto_ID] [bigint] NOT NULL,
	[Nhom_PDA_ID] [bigint] NULL,
	[FApp_M01_ID] [int] NULL,
	[FApp_M01_Label] [nvarchar](200) NULL,
	[FApp_M02_ID] [int] NULL,
	[FApp_M02_Label] [nvarchar](200) NULL,
	[FApp_M03_ID] [int] NULL,
	[FApp_M03_Label] [nvarchar](200) NULL,
	[FApp_M04_ID] [int] NULL,
	[FApp_M04_Label] [nvarchar](200) NULL,
	[FApp_M05_ID] [int] NULL,
	[FApp_M05_Label] [nvarchar](200) NULL,
	[FApp_M06_ID] [int] NULL,
	[FApp_M06_Label] [nvarchar](200) NULL,
	[FApp_M07_ID] [int] NULL,
	[FApp_M07_Label] [nvarchar](200) NULL,
	[FApp_M08_ID] [int] NULL,
	[FApp_M08_Label] [nvarchar](200) NULL,
	[FApp_M09_ID] [int] NULL,
	[FApp_M09_Label] [nvarchar](200) NULL,
	[FApp_M10_ID] [int] NULL,
	[FApp_M10_Label] [nvarchar](200) NULL,
	[FApp_M11_ID] [int] NULL,
	[FApp_M11_Label] [nvarchar](200) NULL,
	[FApp_M12_ID] [int] NULL,
	[FApp_M12_Label] [nvarchar](200) NULL,
	[FApp_M13_ID] [int] NULL,
	[FApp_M13_Label] [nvarchar](200) NULL,
	[FApp_M14_ID] [int] NULL,
	[FApp_M14_Label] [nvarchar](200) NULL,
	[FApp_M15_ID] [int] NULL,
	[FApp_M15_Label] [nvarchar](200) NULL,
	[FApp_M16_ID] [int] NULL,
	[FApp_M16_Label] [nvarchar](200) NULL,
	[FApp_M17_ID] [int] NULL,
	[FApp_M17_Label] [nvarchar](200) NULL,
	[FApp_M18_ID] [int] NULL,
	[FApp_M18_Label] [nvarchar](200) NULL,
	[FApp_M19_ID] [int] NULL,
	[FApp_M19_Label] [nvarchar](200) NULL,
	[FApp_M20_ID] [int] NULL,
	[FApp_M20_Label] [nvarchar](200) NULL,
	[FApp_M21_ID] [int] NULL,
	[FApp_M21_Label] [nvarchar](200) NULL,
	[FApp_M22_ID] [int] NULL,
	[FApp_M22_Label] [nvarchar](200) NULL,
	[FApp_M23_ID] [int] NULL,
	[FApp_M23_Label] [nvarchar](200) NULL,
	[FApp_M24_ID] [int] NULL,
	[FApp_M24_Label] [nvarchar](200) NULL,
	[FApp_M25_ID] [int] NULL,
	[FApp_M25_Label] [nvarchar](200) NULL,
	[FApp_M26_ID] [int] NULL,
	[FApp_M26_Label] [nvarchar](200) NULL,
	[FApp_M27_ID] [int] NULL,
	[FApp_M27_Label] [nvarchar](200) NULL,
	[FApp_M28_ID] [int] NULL,
	[FApp_M28_Label] [nvarchar](200) NULL,
	[FApp_M29_ID] [int] NULL,
	[FApp_M29_Label] [nvarchar](200) NULL,
	[FApp_M30_ID] [int] NULL,
	[FApp_M30_Label] [nvarchar](200) NULL,
	[FApp_M31_ID] [int] NULL,
	[FApp_M31_Label] [nvarchar](200) NULL,
	[FApp_M32_ID] [int] NULL,
	[FApp_M32_Label] [nvarchar](200) NULL,
	[FApp_M33_ID] [int] NULL,
	[FApp_M33_Label] [nvarchar](200) NULL,
	[FApp_M34_ID] [int] NULL,
	[FApp_M34_Label] [nvarchar](200) NULL,
	[FApp_M35_ID] [int] NULL,
	[FApp_M35_Label] [nvarchar](200) NULL,
	[FApp_M36_ID] [int] NULL,
	[FApp_M36_Label] [nvarchar](200) NULL,
	[FApp_M37_ID] [int] NULL,
	[FApp_M37_Label] [nvarchar](200) NULL,
	[FApp_M38_ID] [int] NULL,
	[FApp_M38_Label] [nvarchar](200) NULL,
	[FApp_M39_ID] [int] NULL,
	[FApp_M39_Label] [nvarchar](200) NULL,
	[FApp_M40_ID] [int] NULL,
	[FApp_M40_Label] [nvarchar](200) NULL,
	[FApp_M41_ID] [int] NULL,
	[FApp_M41_Label] [nvarchar](200) NULL,
	[FApp_M42_ID] [int] NULL,
	[FApp_M42_Label] [nvarchar](200) NULL,
	[FApp_M43_ID] [int] NULL,
	[FApp_M43_Label] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Chuc_Nang_App] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbl_Sys_Nhom_PDA]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Nhom_PDA](
	[Auto_ID] [bigint] NOT NULL,
	[Ten_Nhom_PDA] [nvarchar](200) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Nhom_PDA] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Nhom_PDA]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Nhom_PDA]
AS
SELECT A.Auto_ID, A.Ten_Nhom_PDA, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Nhom_PDA AS A
WHERE
	(deleted = 0)
GO
/****** Object:  View [dbo].[view_Sys_Chuc_Nang_App]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Chuc_Nang_App]
AS
SELECT        A.Auto_ID, A.Nhom_PDA_ID, A.FApp_M01_ID, A.FApp_M01_Label, A.FApp_M02_ID, A.FApp_M02_Label, A.FApp_M03_ID, A.FApp_M03_Label, A.FApp_M04_ID, A.FApp_M04_Label, A.FApp_M05_ID, A.FApp_M05_Label, 
                         A.FApp_M06_ID, A.FApp_M06_Label, A.FApp_M07_ID, A.FApp_M07_Label, A.FApp_M08_ID, A.FApp_M08_Label, A.FApp_M09_ID, A.FApp_M09_Label, A.FApp_M10_ID, A.FApp_M10_Label, A.FApp_M11_ID, A.FApp_M11_Label, 
                         A.FApp_M12_ID, A.FApp_M12_Label, A.FApp_M13_ID, A.FApp_M13_Label, A.FApp_M14_ID, A.FApp_M14_Label, A.FApp_M15_ID, A.FApp_M15_Label, A.FApp_M16_ID, A.FApp_M16_Label, A.FApp_M17_ID, A.FApp_M17_Label, 
                         A.FApp_M18_ID, A.FApp_M18_Label, A.FApp_M19_ID, A.FApp_M19_Label, A.FApp_M20_ID, A.FApp_M20_Label, A.FApp_M21_ID, A.FApp_M21_Label, A.FApp_M22_ID, A.FApp_M22_Label, A.FApp_M23_ID, A.FApp_M23_Label, 
                         A.FApp_M24_ID, A.FApp_M24_Label, A.FApp_M25_ID, A.FApp_M25_Label, A.FApp_M26_ID, A.FApp_M26_Label, A.FApp_M27_ID, A.FApp_M27_Label, A.FApp_M28_ID, A.FApp_M28_Label, A.FApp_M29_ID, A.FApp_M29_Label, 
                         A.FApp_M30_ID, A.FApp_M30_Label, A.FApp_M31_ID, A.FApp_M31_Label, A.FApp_M32_ID, A.FApp_M32_Label, A.FApp_M33_ID, A.FApp_M33_Label, A.FApp_M34_ID, A.FApp_M34_Label, A.FApp_M35_ID, A.FApp_M35_Label, 
                         A.FApp_M36_ID, A.FApp_M36_Label, A.FApp_M37_ID, A.FApp_M37_Label, A.FApp_M38_ID, A.FApp_M38_Label, A.FApp_M39_ID, A.FApp_M39_Label, A.FApp_M40_ID, A.FApp_M40_Label, A.FApp_M41_ID, A.FApp_M41_Label, 
                         A.FApp_M42_ID, A.FApp_M42_Label, A.FApp_M43_ID, A.FApp_M43_Label, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, 
                         B.Ten_Nhom_PDA
FROM            dbo.tbl_Sys_Chuc_Nang_App AS A LEFT OUTER JOIN
                         dbo.view_Sys_Nhom_PDA B ON A.Nhom_PDA_ID = B.Auto_ID
WHERE        (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Chuc_Nang]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Chuc_Nang](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_Chuc_Nang] [nvarchar](50) NULL,
	[Ten_Chuc_Nang] [nvarchar](200) NULL,
	[Sort_Priority] [int] NULL,
	[Chuc_Nang_Parent_ID] [bigint] NULL,
	[Nhom_Chuc_Nang_ID] [int] NULL,
	[Func_URL] [nvarchar](200) NULL,
	[Image_URL] [nvarchar](50) NULL,
	[Is_View] [bit] NULL,
	[Is_New] [bit] NULL,
	[Is_Edit] [bit] NULL,
	[Is_Delete] [bit] NULL,
	[Is_Export] [bit] NULL,
	[Khach_Hang_ID] [nvarchar](50) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Chuc_Nang] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Chuc_Nang]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Chuc_Nang]
AS
SELECT Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID, Nhom_Chuc_Nang_ID, Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete, Ghi_Chu, deleted, Created, Created_By, Created_By_Function, 
                  Last_Updated, Last_Updated_By, Last_Updated_By_Function, Is_Export, Khach_Hang_ID
FROM     dbo.tbl_Sys_Chuc_Nang AS A
WHERE  (deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Drill_Down]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Drill_Down](
	[Auto_ID] [bigint] NOT NULL,
	[Field_Name] [nvarchar](50) NULL,
	[Link_URL] [nvarchar](200) NULL,
	[Parameter_Field] [nvarchar](50) NULL,
	[Func_ID] [nvarchar](50) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Drill_Down] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Drill_Down]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Drill_Down]
AS
SELECT A.Auto_ID, A.Field_Name, A.Link_URL, A.Parameter_Field, A.Func_ID, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Drill_Down AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Nhom_Thanh_Vien]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Nhom_Thanh_Vien](
	[Auto_ID] [bigint] NOT NULL,
	[Ten_Nhom_Thanh_Vien] [nvarchar](200) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Nhom_Thanh_Vien] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Nhom_Thanh_Vien]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Nhom_Thanh_Vien]
AS
SELECT A.Auto_ID, A.Ten_Nhom_Thanh_Vien, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Nhom_Thanh_Vien AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Nhom_Thanh_Vien_User]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Nhom_Thanh_Vien_User](
	[Auto_ID] [bigint] NOT NULL,
	[Nhom_Thanh_Vien_ID] [bigint] NULL,
	[Ma_Dang_Nhap] [nvarchar](50) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Nhom_Thanh_Vien_User] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Nhom_Thanh_Vien_User]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Nhom_Thanh_Vien_User]
AS
SELECT A.Auto_ID, A.Nhom_Thanh_Vien_ID, A.Ma_Dang_Nhap, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, B.Ho_Ten, C.Ten_Nhom_Thanh_Vien
FROM     dbo.tbl_Sys_Nhom_Thanh_Vien_User AS A INNER JOIN
                  dbo.view_Sys_Thanh_Vien AS B ON A.Ma_Dang_Nhap = B.Ma_Dang_Nhap INNER JOIN
                  dbo.view_Sys_Nhom_Thanh_Vien AS C ON A.Nhom_Thanh_Vien_ID = C.Auto_ID
WHERE  (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Help_Guide]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Help_Guide](
	[Auto_ID] [bigint] NOT NULL,
	[Khach_Hang_ID] [int] NULL,
	[Ma_Chuc_Nang] [nvarchar](50) NULL,
	[Ngon_Ngu] [nvarchar](50) NULL,
	[Noi_Dung] [ntext] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Help_Guide] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Help_Guide]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Help_Guide]
AS
SELECT A.Auto_ID, A.Khach_Hang_ID, A.Ma_Chuc_Nang, A.Ngon_Ngu, A.Noi_Dung, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Help_Guide AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Webhook]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Webhook](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_Webhook] [nvarchar](50) NULL,
	[Ten_Webhook] [nvarchar](200) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Webhook] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Webhook]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Webhook]
AS
SELECT A.Auto_ID, A.Ma_Webhook, A.Ten_Webhook, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Webhook AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Language]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Language](
	[Auto_ID] [bigint] NOT NULL,
	[Field_Name] [nvarchar](200) NULL,
	[Lang_1] [nvarchar](200) NULL,
	[Lang_2] [nvarchar](200) NULL,
	[Lang_3] [nvarchar](200) NULL,
	[Lang_4] [nvarchar](200) NULL,
	[Lang_5] [nvarchar](200) NULL,
	[Type_ID] [int] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Language] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Language]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Language]
AS
SELECT A.Auto_ID, A.Field_Name, A.Lang_1, A.Lang_2, A.Lang_3, A.Lang_4, A.Lang_5, A.Type_ID, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Language AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Log_API]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Log_API](
	[Auto_ID] [bigint] NOT NULL,
	[Key_No] [nvarchar](50) NULL,
	[API_Source_Name] [nvarchar](50) NULL,
	[API_Function_Name] [nvarchar](50) NULL,
	[Description] [nvarchar](200) NULL,
	[Trang_Thai_ID] [int] NULL,
	[Link_URL] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Log_API] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Log_API]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Log_API]
AS
SELECT A.Auto_ID, A.Key_No, A.API_Source_Name, A.API_Function_Name, A.Description, A.Trang_Thai_ID, A.Link_URL, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Log_API AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Frozen_Column]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Frozen_Column](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_Chuc_Nang] [nvarchar](50) NULL,
	[SL_Cot_Frozen] [int] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Frozen_Column] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Frozen_Column]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Frozen_Column]
AS
SELECT A.Auto_ID, A.Ma_Chuc_Nang, A.SL_Cot_Frozen, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Frozen_Column AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Nhom_PDA_User]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Nhom_PDA_User](
	[Auto_ID] [bigint] NOT NULL,
	[Nhom_PDA_ID] [bigint] NULL,
	[Ma_Dang_Nhap] [nvarchar](50) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Nhom_PDA_User] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Nhom_PDA_User]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Nhom_PDA_User]
AS
SELECT    A.Auto_ID, A.Nhom_PDA_ID, A.Ma_Dang_Nhap, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, 
                      dbo.view_Sys_Nhom_PDA.Ten_Nhom_PDA, dbo.view_Sys_Thanh_Vien.Ho_Ten
FROM         dbo.tbl_Sys_Nhom_PDA_User AS A LEFT OUTER JOIN
                      dbo.view_Sys_Thanh_Vien ON A.Ma_Dang_Nhap = dbo.view_Sys_Thanh_Vien.Ma_Dang_Nhap LEFT OUTER JOIN
                      dbo.view_Sys_Nhom_PDA ON A.Nhom_PDA_ID = dbo.view_Sys_Nhom_PDA.Auto_ID
WHERE     (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Mau_Column]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Mau_Column](
	[Auto_ID] [bigint] NOT NULL,
	[Field_Name] [nvarchar](50) NULL,
	[Ma_So_Mau] [nvarchar](50) NULL,
	[Ghi_Chu] [nvarchar](50) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Mau_Column] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Mau_Column]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Mau_Column]
AS
SELECT A.Auto_ID, A.Field_Name, A.Ma_So_Mau, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Mau_Column AS A
WHERE
	(deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Report_Template_Config]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Report_Template_Config](
	[Auto_ID] [bigint] NOT NULL,
	[Chu_Hang_ID] [bigint] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Report_Template_Config] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Report_Template_Config]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Report_Template_Config]
AS
SELECT A.Auto_ID, A.Chu_Hang_ID, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, 
			B.Ma_Chu_Hang, B.Ten_Viet_Tat, B.Ten_Chu_Hang
FROM   dbo.tbl_Sys_Report_Template_Config AS A LEFT OUTER JOIN
             dbo.view_DM_Chu_Hang AS B ON A.Chu_Hang_ID = B.Auto_ID
WHERE (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_DM_Don_Vi_Tinh]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_DM_Don_Vi_Tinh](
	[Auto_ID] [bigint] NULL,
	[Ten_Don_Vi_Tinh] [nvarchar](200) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_DM_Don_Vi_Tinh]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_DM_Don_Vi_Tinh]
AS
SELECT A.Auto_ID, A.Ten_Don_Vi_Tinh, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_DM_Don_Vi_Tinh AS A
WHERE
	(deleted = 0)

GO
/****** Object:  Table [dbo].[tbl_Sys_Grid_Field]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Grid_Field](
	[Auto_ID] [bigint] NOT NULL,
	[Ten_Grid] [nvarchar](50) NULL,
	[Ma_Chuc_Nang] [nvarchar](50) NULL,
	[Field_Name] [nvarchar](50) NULL,
	[Tieu_De_Column] [nvarchar](200) NULL,
	[Column_Width] [int] NULL,
	[Field_Type_ID] [int] NULL,
	[Field_Name_Parent] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Grid_Field] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Grid_Field]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Grid_Field]
AS
SELECT Auto_ID, Ten_Grid, Ma_Chuc_Nang, Field_Name, Tieu_De_Column, Column_Width, Field_Type_ID, deleted, Created, Created_By, Created_By_Function, Last_Updated, Last_Updated_By, Last_Updated_By_Function, Field_Name_Parent
FROM   dbo.tbl_Sys_Grid_Field AS A
WHERE (deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_DM_Kho]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_DM_Kho](
	[Auto_ID] [bigint] NULL,
	[Ten_Kho] [nvarchar](200) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_DM_Kho]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_DM_Kho]
AS
SELECT A.Auto_ID, A.Ten_Kho, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_DM_Kho AS A
WHERE
	(deleted = 0)


GO
/****** Object:  Table [dbo].[tbl_Sys_Webhook_Chu_Hang]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Webhook_Chu_Hang](
	[Auto_ID] [bigint] NOT NULL,
	[Chu_Hang_ID] [bigint] NULL,
	[Webhook_ID] [bigint] NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Webhook_Chu_Hang] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Webhook_Chu_Hang]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Webhook_Chu_Hang]
AS
SELECT        A.Auto_ID, A.Chu_Hang_ID, A.Webhook_ID, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, 
				A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, B.Ma_Webhook, B.Ten_Webhook,
				C.Ma_Chu_Hang, C.Ten_Chu_Hang, C.Ten_Viet_Tat
FROM            dbo.tbl_Sys_Webhook_Chu_Hang AS A LEFT OUTER JOIN
                         dbo.view_Sys_Webhook B ON A.Webhook_ID = B.Auto_ID LEFT OUTER JOIN
                         dbo.view_DM_Chu_Hang C ON A.Chu_Hang_ID = C.Auto_ID
WHERE        (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Grid_UI_Global]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Grid_UI_Global](
	[Auto_ID] [bigint] NOT NULL,
	[Ma_Chuc_Nang] [nvarchar](50) NULL,
	[Grid_Field_ID] [bigint] NULL,
	[Column_Width] [int] NULL,
	[Sort_Priority] [int] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Grid_UI_Global] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Grid_UI_Global]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Grid_UI_Global]
AS
SELECT A.Auto_ID, A.Column_Width, A.Sort_Priority, A.deleted, A.Created, A.Created_By, A.Created_By_Function, 
			A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, A.Ma_Chuc_Nang, 
			A.Grid_Field_ID, B.Ten_Grid, B.Tieu_De_Column, B.Field_Name, B.Field_Type_ID
FROM   dbo.tbl_Sys_Grid_UI_Global AS A LEFT OUTER JOIN
             dbo.view_Sys_Grid_Field B ON A.Grid_Field_ID = B.Auto_ID
WHERE (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_DM_Kho_User]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_DM_Kho_User](
	[Auto_ID] [bigint] NULL,
	[Ma_Dang_Nhap] [nvarchar](50) NULL,
	[Kho_ID] [bigint] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_DM_Kho_User]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[view_DM_Kho_User]
AS
SELECT A.Auto_ID, A.Kho_ID, A.Ma_Dang_Nhap, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, B.Ho_Ten, C.Ten_Kho
FROM  dbo.tbl_DM_Kho_User AS A INNER JOIN
         dbo.view_Sys_Thanh_Vien AS B ON A.Ma_Dang_Nhap = B.Ma_Dang_Nhap INNER JOIN
         dbo.view_DM_Kho AS C ON A.Kho_ID = C.Auto_ID
WHERE (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Import_Excel_Template_Config]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Import_Excel_Template_Config](
	[Auto_ID] [bigint] NOT NULL,
	[Chu_Hang_ID] [bigint] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Import_Excel_Template_Config] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Import_Excel_Template_Config]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Import_Excel_Template_Config]
AS
SELECT A.Auto_ID, A.Chu_Hang_ID, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, 
             B.Ma_Chu_Hang, B.Ten_Viet_Tat, B.Ten_Chu_Hang
FROM   dbo.tbl_Sys_Import_Excel_Template_Config AS A LEFT OUTER JOIN
             dbo.view_DM_Chu_Hang AS B ON A.Chu_Hang_ID = B.Auto_ID
WHERE (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Phan_Quyen_Chuc_Nang]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Phan_Quyen_Chuc_Nang](
	[Auto_ID] [bigint] NOT NULL,
	[Nhom_Thanh_Vien_ID] [bigint] NULL,
	[Chuc_Nang_ID] [bigint] NULL,
	[Is_Have_View_Permission] [bit] NULL,
	[Is_Have_Add_Permission] [bit] NULL,
	[Is_Have_Edit_Permission] [bit] NULL,
	[Is_Have_Delete_Permission] [bit] NULL,
	[Is_Have_Export_Permission] [bit] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Phan_Quyen_Chuc_Nang] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Phan_Quyen_Chuc_Nang]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Phan_Quyen_Chuc_Nang]
AS
SELECT Auto_ID, Nhom_Thanh_Vien_ID, Chuc_Nang_ID, Is_Have_View_Permission, Is_Have_Add_Permission, Is_Have_Edit_Permission, Is_Have_Delete_Permission, deleted, Created, Created_By, Created_By_Function, Last_Updated, 
                  Last_Updated_By, Last_Updated_By_Function, Is_Have_Export_Permission
FROM     dbo.tbl_Sys_Phan_Quyen_Chuc_Nang AS A
WHERE  (deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_Sys_Auto_Thread]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Auto_Thread](
	[Auto_ID] [bigint] NOT NULL,
	[Thread_Type_ID] [int] NULL,
	[Delay_Second] [int] NULL,
	[STT_Thread_ID] [int] NULL,
	[Ma_Su_Dung] [nvarchar](100) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Auto_Thread] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Auto_Thread]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Auto_Thread]
AS
SELECT Auto_ID, Thread_Type_ID, Delay_Second, STT_Thread_ID, Ghi_Chu, deleted, Created, Created_By, Created_By_Function, Last_Updated, Last_Updated_By, Last_Updated_By_Function, Ma_Su_Dung
FROM   dbo.tbl_Sys_Auto_Thread AS A
WHERE (deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_DM_Loai_San_Pham]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_DM_Loai_San_Pham](
	[Auto_ID] [bigint] NULL,
	[Ma_LSP] [nvarchar](50) NULL,
	[Ten_LSP] [nvarchar](200) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_DM_Loai_San_Pham]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_DM_Loai_San_Pham]
AS
SELECT A.Auto_ID, A.Ma_LSP, A.Ten_LSP, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_DM_Loai_San_Pham AS A
WHERE
	(deleted = 0)


GO
/****** Object:  Table [dbo].[tbl_Sys_Token]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Token](
	[Auto_ID] [bigint] NOT NULL,
	[Token_ID] [nvarchar](50) NULL,
	[Ma_Dang_Nhap] [nvarchar](50) NULL,
	[Token_Expired] [datetime] NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Token] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Token]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Token]
AS
SELECT        A.Auto_ID, A.Token_ID, A.Ma_Dang_Nhap, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function, B.Ho_Ten, 
                         B.Email, B.Dien_Thoai, A.Token_Expired
FROM            dbo.tbl_Sys_Token AS A LEFT OUTER JOIN
                         dbo.view_Sys_Thanh_Vien B ON A.Ma_Dang_Nhap = B.Ma_Dang_Nhap
WHERE        (A.deleted = 0)
GO
/****** Object:  Table [dbo].[tbl_DM_NCC]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_DM_NCC](
	[Auto_ID] [bigint] NULL,
	[Ma_NCC] [nvarchar](50) NULL,
	[Ten_NCC] [nvarchar](200) NULL,
	[Ghi_Chu] [nvarchar](200) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_DM_NCC]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_DM_NCC]
AS
SELECT A.Auto_ID, A.Ma_NCC, A.Ten_NCC, A.Ghi_Chu, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_DM_NCC AS A
WHERE
	(deleted = 0)


GO
/****** Object:  Table [dbo].[tbl_Sys_Hien_An_Column]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_Sys_Hien_An_Column](
	[Auto_ID] [bigint] NOT NULL,
	[Chu_Hang_ID] [bigint] NULL,
	[Field_Name] [nvarchar](50) NULL,
	[Option_ID] [int] NULL,
	[Ma_Chuc_Nang] [nvarchar](50) NULL,
	[deleted] [int] NULL,
	[Created] [datetime] NULL,
	[Created_By] [nvarchar](50) NULL,
	[Created_By_Function] [nvarchar](50) NULL,
	[Last_Updated] [datetime] NULL,
	[Last_Updated_By] [nvarchar](50) NULL,
	[Last_Updated_By_Function] [nvarchar](50) NULL,
 CONSTRAINT [PK_tbl_Sys_Hien_An_Column] PRIMARY KEY CLUSTERED 
(
	[Auto_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[view_Sys_Hien_An_Column]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[view_Sys_Hien_An_Column]
AS
SELECT A.Auto_ID, A.Chu_Hang_ID, A.Field_Name, A.Option_ID, A.Ma_Chuc_Nang, A.deleted, A.Created, A.Created_By, A.Created_By_Function, A.Last_Updated, A.Last_Updated_By, A.Last_Updated_By_Function 
FROM dbo.tbl_Sys_Hien_An_Column AS A
WHERE
	(deleted = 0)
GO
/****** Object:  StoredProcedure [dbo].[F1004_sp_sel_List_Thanh_Vien_Khong_Thuoc_Nhom]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1004_sp_sel_List_Thanh_Vien_Khong_Thuoc_Nhom]
	@Nhom_Thanh_Vien_ID int
	with recompile
AS
BEGIN
	SELECT A.Auto_ID, A.Ma_Dang_Nhap, A.Ho_Ten
	FROM 
		view_Sys_Thanh_Vien A with (nolock) 
	WHERE 
		A.Ma_Dang_Nhap not in (select Ma_Dang_Nhap from view_Sys_Nhom_Thanh_Vien_User where Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID)
	ORDER BY Ma_Dang_Nhap ASC
END
GO
/****** Object:  StoredProcedure [dbo].[F1005_sp_upd_Doi_Mat_Khau_Thanh_Vien]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1005_sp_upd_Doi_Mat_Khau_Thanh_Vien]
	@Auto_ID int,
	@Password nvarchar(50)
	with recompile
AS
BEGIN
	UPDATE tbl_Sys_Thanh_Vien SET
		Mat_Khau = @Password,
		Last_Updated = getdate()
	WHERE
		Auto_ID = @Auto_ID
		END
GO
/****** Object:  StoredProcedure [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_Add]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_Add]
	@Nhom_Thanh_Vien_ID bigint,
	@Chuc_Nang_ID bigint,
	@Is_Have_Add_Permission bit,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
--exec [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_Add] 10000000, 13910600, 0, null, null
BEGIN
	SET NOCOUNT ON;

	declare @Auto_ID bigint = (select top 1 Auto_ID from view_Sys_Phan_Quyen_Chuc_Nang with (nolock) where Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID and Chuc_Nang_ID = @Chuc_Nang_ID)

	if (isnull(@Auto_ID, 0) <> 0)
	begin
		UPDATE tbl_Sys_Phan_Quyen_Chuc_Nang SET
			Is_Have_Add_Permission = @Is_Have_Add_Permission,
			Last_Updated = getdate(),
			Last_Updated_By = @Last_Updated_By,
			Last_Updated_By_Function = @Last_Updated_By_Function
		WHERE
			Auto_ID = @Auto_ID
	end
	else
	begin
		set @Auto_ID = (next value for dbo.Seq_ID)

		INSERT INTO tbl_Sys_Phan_Quyen_Chuc_Nang
		(
			Auto_ID,
			Nhom_Thanh_Vien_ID,
			Chuc_Nang_ID,
			Is_Have_Add_Permission,
			deleted,
			Created,
			Created_By,
			Created_By_Function,
			Last_Updated,
			Last_Updated_By,
			Last_Updated_By_Function
		)
		VALUES
		(
			@Auto_ID,
			@Nhom_Thanh_Vien_ID,
			@Chuc_Nang_ID,
			@Is_Have_Add_Permission,
			0,
			getdate(),
			@Last_Updated_By,
			@Last_Updated_By_Function,
			getdate(),
			@Last_Updated_By,
			@Last_Updated_By_Function
		)
	end
END
GO
/****** Object:  StoredProcedure [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_Delete]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_Delete]
	@Nhom_Thanh_Vien_ID bigint,
	@Chuc_Nang_ID bigint,
	@Is_Have_Delete_Permission bit,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	declare @Auto_ID bigint = (select top 1 Auto_ID from view_Sys_Phan_Quyen_Chuc_Nang with (nolock) where Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID and Chuc_Nang_ID = @Chuc_Nang_ID)

	if (isnull(@Auto_ID, 0) <> 0)
	begin
		UPDATE tbl_Sys_Phan_Quyen_Chuc_Nang SET
			Is_Have_Delete_Permission = @Is_Have_Delete_Permission,
			Last_Updated = getdate(),
			Last_Updated_By = @Last_Updated_By,
			Last_Updated_By_Function = @Last_Updated_By_Function
		WHERE
			Auto_ID = @Auto_ID
	end
	else
	begin
		set @Auto_ID = (next value for dbo.Seq_ID)

		INSERT INTO tbl_Sys_Phan_Quyen_Chuc_Nang
		(
			Auto_ID,
			Nhom_Thanh_Vien_ID,
			Chuc_Nang_ID,
			Is_Have_Delete_Permission,
			deleted,
			Created,
			Created_By,
			Created_By_Function,
			Last_Updated,
			Last_Updated_By,
			Last_Updated_By_Function
		)
		VALUES
		(
			@Auto_ID,
			@Nhom_Thanh_Vien_ID,
			@Chuc_Nang_ID,
			@Is_Have_Delete_Permission,
			0,
			getdate(),
			@Last_Updated_By,
			@Last_Updated_By_Function,
			getdate(),
			@Last_Updated_By,
			@Last_Updated_By_Function
		)
	end
END
GO
/****** Object:  StoredProcedure [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_Edit]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_Edit]
	@Nhom_Thanh_Vien_ID bigint,
	@Chuc_Nang_ID bigint,
	@Is_Have_Edit_Permission bit,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	declare @Auto_ID bigint = (select top 1 Auto_ID from view_Sys_Phan_Quyen_Chuc_Nang with (nolock) where Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID and Chuc_Nang_ID = @Chuc_Nang_ID)

	if (isnull(@Auto_ID, 0) <> 0)
	begin
		UPDATE tbl_Sys_Phan_Quyen_Chuc_Nang SET
			Is_Have_Edit_Permission = @Is_Have_Edit_Permission,
			Last_Updated = getdate(),
			Last_Updated_By = @Last_Updated_By,
			Last_Updated_By_Function = @Last_Updated_By_Function
		WHERE
			Auto_ID = @Auto_ID
	end
	else
	begin
		set @Auto_ID = (next value for dbo.Seq_ID)

		INSERT INTO tbl_Sys_Phan_Quyen_Chuc_Nang
		(
			Auto_ID,
			Nhom_Thanh_Vien_ID,
			Chuc_Nang_ID,
			Is_Have_Edit_Permission,
			deleted,
			Created,
			Created_By,
			Created_By_Function,
			Last_Updated,
			Last_Updated_By,
			Last_Updated_By_Function
		)
		VALUES
		(
			@Auto_ID,
			@Nhom_Thanh_Vien_ID,
			@Chuc_Nang_ID,
			@Is_Have_Edit_Permission,
			0,
			getdate(),
			@Last_Updated_By,
			@Last_Updated_By_Function,
			getdate(),
			@Last_Updated_By,
			@Last_Updated_By_Function
		)
	end
END
GO
/****** Object:  StoredProcedure [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_Export]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_Export]
	@Nhom_Thanh_Vien_ID bigint,
	@Chuc_Nang_ID bigint,
	@Is_Have_Export_Permission bit,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	declare @Auto_ID bigint = (select top 1 Auto_ID from view_Sys_Phan_Quyen_Chuc_Nang with (nolock) where Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID and Chuc_Nang_ID = @Chuc_Nang_ID)

	if (isnull(@Auto_ID, 0) <> 0)
	begin
		UPDATE tbl_Sys_Phan_Quyen_Chuc_Nang SET
			Is_Have_Export_Permission = @Is_Have_Export_Permission,
			Last_Updated = getdate(),
			Last_Updated_By = @Last_Updated_By,
			Last_Updated_By_Function = @Last_Updated_By_Function
		WHERE
			Auto_ID = @Auto_ID
	end
	else
	begin
		set @Auto_ID = (next value for dbo.Seq_ID)

		INSERT INTO tbl_Sys_Phan_Quyen_Chuc_Nang
		(
			Auto_ID,
			Nhom_Thanh_Vien_ID,
			Chuc_Nang_ID,
			Is_Have_Export_Permission,
			deleted,
			Created,
			Created_By,
			Created_By_Function,
			Last_Updated,
			Last_Updated_By,
			Last_Updated_By_Function
		)
		VALUES
		(
			@Auto_ID,
			@Nhom_Thanh_Vien_ID,
			@Chuc_Nang_ID,
			@Is_Have_Export_Permission,
			0,
			getdate(),
			@Last_Updated_By,
			@Last_Updated_By_Function,
			getdate(),
			@Last_Updated_By,
			@Last_Updated_By_Function
		)
	end
END
GO
/****** Object:  StoredProcedure [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_View]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1005_sp_upd_Phan_Quyen_Chuc_Nang_View]
	@Nhom_Thanh_Vien_ID bigint,
	@Chuc_Nang_ID bigint,
	@Is_Have_View_Permission bit,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	declare @Auto_ID bigint = (select top 1 Auto_ID from view_Sys_Phan_Quyen_Chuc_Nang with (nolock) where Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID and Chuc_Nang_ID = @Chuc_Nang_ID)

	if (isnull(@Auto_ID, 0) <> 0)
	begin
		UPDATE tbl_Sys_Phan_Quyen_Chuc_Nang SET
			Is_Have_View_Permission = @Is_Have_View_Permission,
			Last_Updated = getdate(),
			Last_Updated_By = @Last_Updated_By,
			Last_Updated_By_Function = @Last_Updated_By_Function
		WHERE
			Auto_ID = @Auto_ID
	end
	else
	begin
		set @Auto_ID = (next value for dbo.Seq_ID)

		INSERT INTO tbl_Sys_Phan_Quyen_Chuc_Nang
		(
			Auto_ID,
			Nhom_Thanh_Vien_ID,
			Chuc_Nang_ID,
			Is_Have_View_Permission,
			deleted,
			Created,
			Created_By,
			Created_By_Function,
			Last_Updated,
			Last_Updated_By,
			Last_Updated_By_Function
		)
		VALUES
		(
			@Auto_ID,
			@Nhom_Thanh_Vien_ID,
			@Chuc_Nang_ID,
			@Is_Have_View_Permission,
			0,
			getdate(),
			@Last_Updated_By,
			@Last_Updated_By_Function,
			getdate(),
			@Last_Updated_By,
			@Last_Updated_By_Function
		)
	end
END
GO
/****** Object:  StoredProcedure [dbo].[F1006_sp_sel_List_Log_Nhat_Ky_Dang_Nhap_By_User]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1006_sp_sel_List_Log_Nhat_Ky_Dang_Nhap_By_User]
	@Ma_Dang_Nhap nvarchar(50)
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_Dang_Nhap, User_Agent, IP, Created
	FROM 
		view_Log_Nhat_Ky_Dang_Nhap with (nolock)
	where
		Ma_Dang_Nhap = @Ma_Dang_Nhap
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[F1006_sp_sel_List_Log_Nhat_Ky_Truy_Cap_Chuc_Nang_By_User]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1006_sp_sel_List_Log_Nhat_Ky_Truy_Cap_Chuc_Nang_By_User]
	@Ma_Dang_Nhap nvarchar(50)
	with recompile
AS
BEGIN
	SELECT top 300 Auto_ID, Ma_Dang_Nhap, Ma_Chuc_Nang, Ten_Chuc_Nang, Created, Created_By
	FROM 
		view_Log_Nhat_Ky_Truy_Cap_Chuc_Nang with (nolock)
	where
		Ma_Dang_Nhap = @Ma_Dang_Nhap
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[F1007_sp_upd_Doi_Mat_Khau]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1007_sp_upd_Doi_Mat_Khau]
	@Auto_ID int,
	@Mat_Khau_Moi nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	update tbl_Sys_Thanh_Vien set
		Mat_Khau = @Mat_Khau_Moi
	where
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[F1009_sp_sel_List_Nhat_Ky_Dang_Nhap_Ca_Nhan]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1009_sp_sel_List_Nhat_Ky_Dang_Nhap_Ca_Nhan]
	@Date_From datetime,
	@Date_To datetime,
	@Ma_Dang_Nhap nvarchar(50)
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Dang_Nhap, IP, User_Agent, Created
	FROM 
		view_Log_Nhat_Ky_Dang_Nhap with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
		and Ma_Dang_Nhap = @Ma_Dang_Nhap
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[F1010_sp_sel_List_Nhat_Ky_Dang_Nhap_All]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1010_sp_sel_List_Nhat_Ky_Dang_Nhap_All]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Dang_Nhap, IP, User_Agent, Created
	FROM 
		view_Log_Nhat_Ky_Dang_Nhap with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[F1023_sp_sel_List_FApp_Func]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1023_sp_sel_List_FApp_Func]
    with recompile
AS
BEGIN
	SELECT 3001 as FApp_ID, N'Nhập kho | Pallet - 3001' as FApp_Label
	union all
	SELECT 3002 as FApp_ID, N'Putaway | Pallet - 3002' as FApp_Label
	
	Order by FApp_ID ASC
END
GO
/****** Object:  StoredProcedure [dbo].[F1025_sp_sel_List_Sys_Thanh_Vien]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1025_sp_sel_List_Sys_Thanh_Vien]
    with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_Dang_Nhap, Mat_Khau, Ho_Ten, Email, Dien_Thoai, Hinh_Dai_Dien_URL, Trang_Thai_ID, Ten_Nhom_Thanh_Vien_Text, Ghi_Chu
	FROM view_Sys_Thanh_Vien
	where
		(Ma_Dang_Nhap not in (select Ma_Dang_Nhap from view_Sys_Nhom_Thanh_Vien_User where Nhom_Thanh_Vien_ID = 10000000))
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[F1025_sp_upd_Reset_Mat_Khau_Thanh_Vien]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[F1025_sp_upd_Reset_Mat_Khau_Thanh_Vien]
	@Auto_ID bigint,
	@Mat_Khau nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
as
begin
	SET NOCOUNT ON;

	if (isnull(@Mat_Khau, '') = '')
	begin
		RAISERROR(N'Mật khẩu không được để trống.', 11, 1)
		return
	end
 
	UPDATE tbl_Sys_Thanh_Vien SET
		Mat_Khau = @Mat_Khau,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
end
GO
/****** Object:  StoredProcedure [dbo].[F1029_sp_sel_List_Nhat_Ky_Import_Excel]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1029_sp_sel_List_Nhat_Ky_Import_Excel]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Link_URL, Trang_Thai_ID, Ghi_Chu, Created, Created_By
	FROM 
		view_Log_Import_Excel with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[F1037_sp_sel_List_Thanh_Vien_Khong_Thuoc_Nhom_PDA]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1037_sp_sel_List_Thanh_Vien_Khong_Thuoc_Nhom_PDA]
	@Nhom_PDA_ID int
	with recompile
AS
BEGIN
	SELECT A.Auto_ID, A.Ma_Dang_Nhap, A.Ho_Ten
	FROM 
		view_Sys_Thanh_Vien A with (nolock) 
	WHERE 
		A.Ma_Dang_Nhap not in (select Ma_Dang_Nhap from view_Sys_Nhom_PDA_User where Nhom_PDA_ID = @Nhom_PDA_ID)
	ORDER BY Ma_Dang_Nhap ASC
END
GO
/****** Object:  StoredProcedure [dbo].[F1038_sp_ins_API_Source_Chu_Hang_Function]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F1038_sp_ins_API_Source_Chu_Hang_Function]
	@API_Source_ID bigint,
	@API_Source_Chu_Hang_ID bigint,
	@API_Source_Function_ID bigint,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@API_Source_Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn API Source chủ hàng', 11, 1)
		return
	end

	if (isnull(@API_Source_Function_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn API Source function', 11, 1)
		return
	end

	--kiem tra @API_Source_Function_ID có thuộc API source function của API_Source 
	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_API_Source_Function with (nolock) 
									where API_Source_ID = @API_Source_ID and Auto_ID = @API_Source_Function_ID)

	if(isnull(@Check_ID_1, 0) = 0)
	begin
		RAISERROR(N'API Source function này không thuộc API Source này', 11, 1)
		return
	end


	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_API_Source_Chu_Hang_Function with (nolock) 
									where API_Source_Chu_Hang_ID = @API_Source_Chu_Hang_ID
										and API_Source_Function_ID = @API_Source_Function_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'API Source function này đã khai báo', 11, 1)
		return
	end


	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_API_Source_Chu_Hang_Function
	(
		Auto_ID,
		API_Source_Chu_Hang_ID,
		API_Source_Function_ID,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@API_Source_Chu_Hang_ID,
		@API_Source_Function_ID,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[F1038_sp_upd_API_Source_Chu_Hang_Function]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[F1038_sp_upd_API_Source_Chu_Hang_Function]
	@API_Source_ID bigint,
	@Auto_ID bigint,
	@API_Source_Chu_Hang_ID bigint,
	@API_Source_Function_ID bigint,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	
	if (isnull(@API_Source_Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn API Source chủ hàng', 11, 1)
		return
	end

	if (isnull(@API_Source_Function_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn API Source function', 11, 1)
		return
	end

	--kiem tra @API_Source_Function_ID có thuộc API source function của API_Source 
	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_API_Source_Function with (nolock) 
									where API_Source_ID = @API_Source_ID and Auto_ID = @API_Source_Function_ID)

	if(isnull(@Check_ID_1, 0) = 0)
	begin
		RAISERROR(N'API Source function này không thuộc API Source này', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_API_Source_Chu_Hang_Function with (nolock) 
									where API_Source_Chu_Hang_ID = @API_Source_Chu_Hang_ID
										and API_Source_Function_ID = @API_Source_Function_ID
										and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'API Source function này đã khai báo', 11, 1)
		return
	end

	UPDATE tbl_Sys_API_Source_Chu_Hang_Function SET
		API_Source_Chu_Hang_ID = @API_Source_Chu_Hang_ID,
		API_Source_Function_ID = @API_Source_Function_ID,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[F1041_1_sp_upd_Log_API_Trang_Thai_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[F1041_1_sp_upd_Log_API_Trang_Thai_ID]
	@Auto_ID bigint,
	@Trang_Thai_ID int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Log_API SET		
		Trang_Thai_ID = @Trang_Thai_ID,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[F3001_sp_sel_List_By_Xuat_Kho_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[F3001_sp_sel_List_By_Xuat_Kho_ID]
	@Xuat_Kho_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_XNK_Xuat_Kho_Raw_Data with (nolock)
	WHERE
		Xuat_Kho_ID = @Xuat_Kho_ID
END
GO
/****** Object:  StoredProcedure [dbo].[F7001_sp_sel_List_By_Nhap_Kho_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[F7001_sp_sel_List_By_Nhap_Kho_ID]
	@Nhap_Kho_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_XNK_Nhap_Kho_Raw_Data with (nolock)
	WHERE
		Nhap_Kho_ID = @Nhap_Kho_ID
END

GO
/****** Object:  StoredProcedure [dbo].[F7001_sp_sel_List_By_NhapKho_And_SanPham]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[F7001_sp_sel_List_By_NhapKho_And_SanPham]
    @Nhap_Kho_ID BIGINT,
    @San_Pham_ID BIGINT
AS
BEGIN
    SELECT TOP 1 *
    FROM view_XNK_Nhap_Kho_Raw_Data
    WHERE Nhap_Kho_ID = @Nhap_Kho_ID AND San_Pham_ID = @San_Pham_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_104_CH_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[FQ_104_CH_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_DM_Chu_Hang SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_104_CH_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[FQ_104_CH_sp_ins_Insert]
	@Ma_Chu_Hang nvarchar(50),
	@Ten_Viet_Tat nvarchar(200),
	@Ten_Chu_Hang nvarchar(200),
	@Dia_Chi nvarchar(200),
	@Dien_Thoai nvarchar(200),
	@Email nvarchar(200),
	@MST nvarchar(50),
	@Header_Title nvarchar(50),
	@Ghi_Chu nvarchar(200),
	@Image_URL_Thumb nvarchar(200),
	@Image_URL nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chu_Hang = LTRIM(RTRIM(@Ma_Chu_Hang))
	set @Ten_Viet_Tat = LTRIM(RTRIM(@Ten_Viet_Tat))
	set @Ten_Chu_Hang = LTRIM(RTRIM(@Ten_Chu_Hang))
	set @Dia_Chi = LTRIM(RTRIM(@Dia_Chi))
	set @Dien_Thoai = LTRIM(RTRIM(@Dien_Thoai))
	set @Email = LTRIM(RTRIM(@Email))
	set @MST = LTRIM(RTRIM(@MST))
	set @Header_Title = LTRIM(RTRIM(@Header_Title))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))
	set @Image_URL_Thumb = LTRIM(RTRIM(@Image_URL_Thumb))
	set @Image_URL = LTRIM(RTRIM(@Image_URL))

	if (isnull(@Ma_Chu_Hang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chủ hàng.', 11, 1)
		return
	end

	if (isnull(@Ten_Viet_Tat, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên viết tắt.', 11, 1)
		return
	end

	if (isnull(@Ten_Chu_Hang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên chủ hàng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_Chu_Hang with (nolock) where Ma_Chu_Hang = @Ma_Chu_Hang)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chủ hàng đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_DM_Chu_Hang with (nolock) where Ten_Viet_Tat = @Ten_Viet_Tat)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên viết tắt đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_3 bigint = (select top 1 Auto_ID from view_DM_Chu_Hang with (nolock) where Ten_Chu_Hang = @Ten_Chu_Hang)
	if(isnull(@Check_ID_3, 0) > 0)
	begin
		RAISERROR(N'Tên chủ hàng đã tồn tại.', 11, 1)
		return
	end

	if (isnull(@MST, '') <> '')
	begin
		declare @Auto_ID_Exits int
		set @Auto_ID_Exits = (select Auto_ID from view_DM_Chu_Hang  where MST = @MST)

		if(isnull(@Auto_ID_Exits, 0) > 0)
		begin
			RAISERROR(N'MST đã tồn tại, xin vui lòng nhập lại tên khác.', 11, 1)
			return
		end 
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_DM_Chu_Hang
	(
		Auto_ID,
		Ma_Chu_Hang,
		Ten_Viet_Tat,
		Ten_Chu_Hang,
		Dia_Chi,
		Dien_Thoai,
		Email,
		MST,
		Header_Title,
		Ghi_Chu,
		Image_URL_Thumb,
		Image_URL,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Chu_Hang,
		@Ten_Viet_Tat,
		@Ten_Chu_Hang,
		@Dia_Chi,
		@Dien_Thoai,
		@Email,
		@MST,
		@Header_Title,
		@Ghi_Chu,
		@Image_URL_Thumb,
		@Image_URL,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_104_CH_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[FQ_104_CH_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_DM_Chu_Hang with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_104_CH_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[FQ_104_CH_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Chu_Hang, Ten_Viet_Tat, Ten_Chu_Hang, Dia_Chi, Dien_Thoai, Email, MST, Header_Title, Ghi_Chu, Image_URL_Thumb, Image_URL
	FROM 
		view_DM_Chu_Hang with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_104_CH_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[FQ_104_CH_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Ma_Chu_Hang, Ten_Viet_Tat, Ten_Chu_Hang, Dia_Chi, Dien_Thoai, Email, MST, 
		Header_Title, Ghi_Chu, Image_URL_Thumb, Image_URL
	FROM 
		view_DM_Chu_Hang with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_104_CH_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[FQ_104_CH_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_Chu_Hang nvarchar(50),
	@Ten_Viet_Tat nvarchar(200),
	@Ten_Chu_Hang nvarchar(200),
	@Dia_Chi nvarchar(200),
	@Dien_Thoai nvarchar(200),
	@Email nvarchar(200),
	@MST nvarchar(50),
	@Header_Title nvarchar(50),
	@Ghi_Chu nvarchar(200),
	@Image_URL_Thumb nvarchar(200),
	@Image_URL nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chu_Hang = LTRIM(RTRIM(@Ma_Chu_Hang))
	set @Ten_Viet_Tat = LTRIM(RTRIM(@Ten_Viet_Tat))
	set @Ten_Chu_Hang = LTRIM(RTRIM(@Ten_Chu_Hang))
	set @Dia_Chi = LTRIM(RTRIM(@Dia_Chi))
	set @Dien_Thoai = LTRIM(RTRIM(@Dien_Thoai))
	set @Email = LTRIM(RTRIM(@Email))
	set @MST = LTRIM(RTRIM(@MST))
	set @Header_Title = LTRIM(RTRIM(@Header_Title))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))
	set @Image_URL_Thumb = LTRIM(RTRIM(@Image_URL_Thumb))
	set @Image_URL = LTRIM(RTRIM(@Image_URL))

	if (isnull(@Ma_Chu_Hang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chủ hàng.', 11, 1)
		return
	end

	if (isnull(@Ten_Viet_Tat, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên viết tắt.', 11, 1)
		return
	end

	if (isnull(@Ten_Chu_Hang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên chủ hàng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_Chu_Hang with (nolock) where Ma_Chu_Hang = @Ma_Chu_Hang and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chủ hàng đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_DM_Chu_Hang with (nolock) where Ten_Viet_Tat = @Ten_Viet_Tat and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên viết tắt đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_3 bigint = (select top 1 Auto_ID from view_DM_Chu_Hang with (nolock) where Ten_Chu_Hang = @Ten_Chu_Hang and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_3, 0) > 0)
	begin
		RAISERROR(N'Tên chủ hàng đã tồn tại.', 11, 1)
		return
	end

	if (isnull(@MST, '') <> '')
	begin
		declare @Auto_ID_Exits int
		set @Auto_ID_Exits = (select Auto_ID from view_DM_Chu_Hang  where MST = @MST and Auto_ID <> @Auto_ID)

		if(isnull(@Auto_ID_Exits, 0) > 0)
		begin
			RAISERROR(N'MST đã tồn tại, xin vui lòng nhập lại tên khác.', 11, 1)
			return
		end 
	end
	UPDATE tbl_DM_Chu_Hang SET
		Ma_Chu_Hang = @Ma_Chu_Hang,
		Ten_Viet_Tat = @Ten_Viet_Tat,
		Ten_Chu_Hang = @Ten_Chu_Hang,
		Dia_Chi = @Dia_Chi,
		Dien_Thoai = @Dien_Thoai,
		Email = @Email,
		MST = @MST,
		Header_Title = @Header_Title,
		Ghi_Chu = @Ghi_Chu,
		Image_URL_Thumb = @Image_URL_Thumb,
		Image_URL = @Image_URL,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_110_DVT_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_110_DVT_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_DM_Don_Vi_Tinh SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_110_DVT_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_110_DVT_sp_ins_Insert]
	@Ten_Don_Vi_Tinh nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Don_Vi_Tinh = LTRIM(RTRIM(@Ten_Don_Vi_Tinh))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ten_Don_Vi_Tinh, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên đơn vị tính.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_Don_Vi_Tinh with (nolock) where Ten_Don_Vi_Tinh = @Ten_Don_Vi_Tinh)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Tên đơn vị tính đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_DM_Don_Vi_Tinh
	(
		Auto_ID,
		Ten_Don_Vi_Tinh,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ten_Don_Vi_Tinh,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_110_DVT_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_110_DVT_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_DM_Don_Vi_Tinh with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_110_DVT_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_110_DVT_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ten_Don_Vi_Tinh, Ghi_Chu
	FROM 
		view_DM_Don_Vi_Tinh with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_110_DVT_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_110_DVT_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Ten_Don_Vi_Tinh, Ghi_Chu
	FROM 
		view_DM_Don_Vi_Tinh with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_110_DVT_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_110_DVT_sp_upd_Update]
	@Auto_ID bigint,
	@Ten_Don_Vi_Tinh nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Don_Vi_Tinh = LTRIM(RTRIM(@Ten_Don_Vi_Tinh))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ten_Don_Vi_Tinh, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên đơn vị tính.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_Don_Vi_Tinh with (nolock) where Ten_Don_Vi_Tinh = @Ten_Don_Vi_Tinh and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Tên đơn vị tính đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_DM_Don_Vi_Tinh SET
		Ten_Don_Vi_Tinh = @Ten_Don_Vi_Tinh,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_114_K_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_114_K_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_DM_Kho SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_114_K_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_114_K_sp_ins_Insert]
	@Ten_Kho nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Kho = LTRIM(RTRIM(@Ten_Kho))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ten_Kho, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên kho.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_Kho with (nolock) where Ten_Kho = @Ten_Kho)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Tên kho đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_DM_Kho
	(
		Auto_ID,
		Ten_Kho,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ten_Kho,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_114_K_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_114_K_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_DM_Kho with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_114_K_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_114_K_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ten_Kho, Ghi_Chu
	FROM 
		view_DM_Kho with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_114_K_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_114_K_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Ten_Kho, Ghi_Chu
	FROM 
		view_DM_Kho with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_114_K_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_114_K_sp_upd_Update]
	@Auto_ID bigint,
	@Ten_Kho nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Kho = LTRIM(RTRIM(@Ten_Kho))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ten_Kho, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên kho.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_Kho with (nolock) where Ten_Kho = @Ten_Kho and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Tên kho đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_DM_Kho SET
		Ten_Kho = @Ten_Kho,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_117_KU_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_117_KU_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_DM_Kho_User SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_117_KU_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_117_KU_sp_ins_Insert]
	@Ma_Dang_Nhap nvarchar(50),
	@Kho_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))

	if (isnull(@Ma_Dang_Nhap, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã đăng nhập.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_Kho_User with (nolock) where Ma_Dang_Nhap = @Ma_Dang_Nhap and Kho_ID = @Kho_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã đăng nhập đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_DM_Kho_User
	(
		Auto_ID,
		Ma_Dang_Nhap,
		Kho_ID,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Dang_Nhap,
		@Kho_ID,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_117_KU_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_117_KU_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_DM_Kho_User with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_117_KU_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_117_KU_sp_sel_List_By_Created]
	@Kho_ID bigint,
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Dang_Nhap, Kho_ID
	FROM 
		view_DM_Kho_User with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
		and Kho_ID = @Kho_ID
	ORDER BY Auto_ID DESC
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_117_KU_sp_sel_List_By_Kho_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_117_KU_sp_sel_List_By_Kho_ID]
	@Kho_ID int
	with recompile
AS
BEGIN
	SELECT Auto_ID, Kho_ID, Ma_Dang_Nhap, Ho_Ten
	FROM 
		view_DM_Kho_User with (nolock) 
	WHERE 
		Kho_ID = @Kho_ID
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_117_KU_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_117_KU_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Ma_Dang_Nhap, Kho_ID
	FROM 
		view_DM_Kho_User with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_117_KU_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_117_KU_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_Dang_Nhap nvarchar(50),
	@Kho_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))

	if (isnull(@Ma_Dang_Nhap, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã đăng nhập.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_Kho_User with (nolock) where Ma_Dang_Nhap = @Ma_Dang_Nhap and Kho_ID = @Kho_ID and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã đăng nhập đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_DM_Kho_User SET
		Ma_Dang_Nhap = @Ma_Dang_Nhap,
		Kho_ID = @Kho_ID,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_122_LSP_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_122_LSP_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_DM_Loai_San_Pham SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_122_LSP_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_122_LSP_sp_ins_Insert]
	@Ma_LSP nvarchar(50),
	@Ten_LSP nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_LSP = LTRIM(RTRIM(@Ma_LSP))
	set @Ten_LSP = LTRIM(RTRIM(@Ten_LSP))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_LSP, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Ma_LSP.', 11, 1)
		return
	end

	if (isnull(@Ten_LSP, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Ten_LSP.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_Loai_San_Pham with (nolock) where Ma_LSP = @Ma_LSP)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Ma_LSP đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_DM_Loai_San_Pham with (nolock) where Ten_LSP = @Ten_LSP)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Ten_LSP đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_DM_Loai_San_Pham
	(
		Auto_ID,
		Ma_LSP,
		Ten_LSP,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_LSP,
		@Ten_LSP,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_122_LSP_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_122_LSP_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_DM_Loai_San_Pham with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_122_LSP_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_122_LSP_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_LSP, Ten_LSP, Ghi_Chu
	FROM 
		view_DM_Loai_San_Pham with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_122_LSP_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_122_LSP_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Ma_LSP, Ten_LSP, Ghi_Chu
	FROM 
		view_DM_Loai_San_Pham with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_122_LSP_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_122_LSP_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_LSP nvarchar(50),
	@Ten_LSP nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_LSP = LTRIM(RTRIM(@Ma_LSP))
	set @Ten_LSP = LTRIM(RTRIM(@Ten_LSP))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_LSP, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Ma_LSP.', 11, 1)
		return
	end

	if (isnull(@Ten_LSP, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Ten_LSP.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_Loai_San_Pham with (nolock) where Ma_LSP = @Ma_LSP and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Ma_LSP đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_DM_Loai_San_Pham with (nolock) where Ten_LSP = @Ten_LSP and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Ten_LSP đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_DM_Loai_San_Pham SET
		Ma_LSP = @Ma_LSP,
		Ten_LSP = @Ten_LSP,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_123_N_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_123_N_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_DM_NCC SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_123_N_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_123_N_sp_ins_Insert]
	@Ma_NCC nvarchar(50),
	@Ten_NCC nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_NCC = LTRIM(RTRIM(@Ma_NCC))
	set @Ten_NCC = LTRIM(RTRIM(@Ten_NCC))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_NCC, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã nhà cung cấp.', 11, 1)
		return
	end

	if (isnull(@Ten_NCC, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên NCC.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_NCC with (nolock) where Ma_NCC = @Ma_NCC)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã nhà cung cấp đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_DM_NCC with (nolock) where Ten_NCC = @Ten_NCC)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên NCC đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_DM_NCC
	(
		Auto_ID,
		Ma_NCC,
		Ten_NCC,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_NCC,
		@Ten_NCC,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_123_N_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_123_N_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_DM_NCC with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_123_N_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_123_N_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_NCC, Ten_NCC, Ghi_Chu
	FROM 
		view_DM_NCC with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_123_N_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_123_N_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Ma_NCC, Ten_NCC, Ghi_Chu
	FROM 
		view_DM_NCC with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_123_N_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_123_N_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_NCC nvarchar(50),
	@Ten_NCC nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_NCC = LTRIM(RTRIM(@Ma_NCC))
	set @Ten_NCC = LTRIM(RTRIM(@Ten_NCC))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_NCC, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã nhà cung cấp.', 11, 1)
		return
	end

	if (isnull(@Ten_NCC, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên NCC.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_NCC with (nolock) where Ma_NCC = @Ma_NCC and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã nhà cung cấp đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_DM_NCC with (nolock) where Ten_NCC = @Ten_NCC and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên NCC đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_DM_NCC SET
		Ma_NCC = @Ma_NCC,
		Ten_NCC = @Ten_NCC,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_165_SP_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_165_SP_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_DM_San_Pham SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_165_SP_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_165_SP_sp_ins_Insert]
	@Ma_San_Pham nvarchar(50),
	@Ten_San_Pham nvarchar(200),
	@Loai_San_Pham_ID bigint,
	@Don_Vi_Tinh_ID bigint,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_San_Pham = LTRIM(RTRIM(@Ma_San_Pham))
	set @Ten_San_Pham = LTRIM(RTRIM(@Ten_San_Pham))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_San_Pham, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã sản phẩm.', 11, 1)
		return
	end

	if (isnull(@Ten_San_Pham, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên sản phẩm.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_San_Pham with (nolock) where Ma_San_Pham = @Ma_San_Pham)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã sản phẩm đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_DM_San_Pham with (nolock) where Ten_San_Pham = @Ten_San_Pham)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên sản phẩm đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_DM_San_Pham
	(
		Auto_ID,
		Ma_San_Pham,
		Ten_San_Pham,
		Loai_San_Pham_ID,
		Don_Vi_Tinh_ID,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_San_Pham,
		@Ten_San_Pham,
		@Loai_San_Pham_ID,
		@Don_Vi_Tinh_ID,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_165_SP_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_165_SP_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_DM_San_Pham with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_165_SP_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_165_SP_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_San_Pham, Ten_San_Pham, Loai_San_Pham_ID, Don_Vi_Tinh_ID, Ghi_Chu
	FROM 
		view_DM_San_Pham with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_165_SP_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_165_SP_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Ma_San_Pham, Ten_San_Pham, Loai_San_Pham_ID, Don_Vi_Tinh_ID, Ghi_Chu
	FROM 
		view_DM_San_Pham with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_165_SP_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_165_SP_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_San_Pham nvarchar(50),
	@Ten_San_Pham nvarchar(200),
	@Loai_San_Pham_ID bigint,
	@Don_Vi_Tinh_ID bigint,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_San_Pham = LTRIM(RTRIM(@Ma_San_Pham))
	set @Ten_San_Pham = LTRIM(RTRIM(@Ten_San_Pham))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_San_Pham, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã sản phẩm.', 11, 1)
		return
	end

	if (isnull(@Ten_San_Pham, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên sản phẩm.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_DM_San_Pham with (nolock) where Ma_San_Pham = @Ma_San_Pham and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã sản phẩm đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_DM_San_Pham with (nolock) where Ten_San_Pham = @Ten_San_Pham and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên sản phẩm đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_DM_San_Pham SET
		Ma_San_Pham = @Ma_San_Pham,
		Ten_San_Pham = @Ten_San_Pham,
		Loai_San_Pham_ID = @Loai_San_Pham_ID,
		Don_Vi_Tinh_ID = @Don_Vi_Tinh_ID,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_401_A_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_401_A_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Log_API SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_401_A_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_401_A_sp_ins_Insert]
	@Key_No nvarchar(50),
	@API_Source_Name nvarchar(50),
	@API_Function_Name nvarchar(50),
	@Description nvarchar(200),
	@Trang_Thai_ID int,
	@Link_URL nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Key_No = LTRIM(RTRIM(@Key_No))
	set @API_Source_Name = LTRIM(RTRIM(@API_Source_Name))
	set @API_Function_Name = LTRIM(RTRIM(@API_Function_Name))
	set @Description = LTRIM(RTRIM(@Description))
	set @Link_URL = LTRIM(RTRIM(@Link_URL))

	if (isnull(@API_Source_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập API_Source_Name.', 11, 1)
		return
	end

	if (isnull(@API_Function_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập API_Function_Name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Log_API with (nolock) where API_Source_Name = @API_Source_Name)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'API_Source_Name đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Log_API with (nolock) where API_Function_Name = @API_Function_Name)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'API_Function_Name đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Log_API
	(
		Auto_ID,
		Key_No,
		API_Source_Name,
		API_Function_Name,
		Description,
		Trang_Thai_ID,
		Link_URL,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Key_No,
		@API_Source_Name,
		@API_Function_Name,
		@Description,
		@Trang_Thai_ID,
		@Link_URL,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_401_A_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_401_A_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Log_API with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_401_A_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_401_A_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Key_No, API_Source_Name, API_Function_Name, Description, Trang_Thai_ID, Link_URL,
		Created, Created_By, Created_By_Function, Last_Updated, Last_Updated_By, Last_Updated_By_Function
	FROM 
		view_Log_API with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_401_A_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_401_A_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Key_No, API_Function_Name, Trang_Thai_ID, API_Source_Name, Created, Last_Updated
	FROM 
		view_Log_API with (nolock)
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_401_A_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_401_A_sp_upd_Update]
	@Auto_ID bigint,
	@Key_No nvarchar(50),
	@API_Source_Name nvarchar(50),
	@API_Function_Name nvarchar(50),
	@Description nvarchar(200),
	@Trang_Thai_ID int,
	@Link_URL nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Key_No = LTRIM(RTRIM(@Key_No))
	set @API_Source_Name = LTRIM(RTRIM(@API_Source_Name))
	set @API_Function_Name = LTRIM(RTRIM(@API_Function_Name))
	set @Description = LTRIM(RTRIM(@Description))
	set @Link_URL = LTRIM(RTRIM(@Link_URL))

	if (isnull(@API_Source_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập API_Source_Name.', 11, 1)
		return
	end

	if (isnull(@API_Function_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập API_Function_Name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Log_API with (nolock) where API_Source_Name = @API_Source_Name and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'API_Source_Name đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Log_API with (nolock) where API_Function_Name = @API_Function_Name and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'API_Function_Name đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Log_API SET
		Key_No = @Key_No,
		API_Source_Name = @API_Source_Name,
		API_Function_Name = @API_Function_Name,
		Description = @Description,
		Trang_Thai_ID = @Trang_Thai_ID,
		Link_URL = @Link_URL,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_422_IE_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_422_IE_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Log_Import_Excel SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_422_IE_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_422_IE_sp_ins_Insert]
	@Ma_Chuc_Nang nvarchar(50),
	@Ten_Chuc_Nang nvarchar(200),
	@Link_URL nvarchar(200),
	@Trang_Thai_ID int,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Ten_Chuc_Nang = LTRIM(RTRIM(@Ten_Chuc_Nang))
	set @Link_URL = LTRIM(RTRIM(@Link_URL))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Log_Import_Excel
	(
		Auto_ID,
		Ma_Chuc_Nang,
		Ten_Chuc_Nang,
		Link_URL,
		Trang_Thai_ID,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Chuc_Nang,
		@Ten_Chuc_Nang,
		@Link_URL,
		@Trang_Thai_ID,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_422_IE_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_422_IE_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Log_Import_Excel with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_422_IE_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_422_IE_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Link_URL, Trang_Thai_ID, Ghi_Chu
	FROM 
		view_Log_Import_Excel with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_422_IE_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_422_IE_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_Chuc_Nang nvarchar(50),
	@Ten_Chuc_Nang nvarchar(200),
	@Link_URL nvarchar(200),
	@Trang_Thai_ID int,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Ten_Chuc_Nang = LTRIM(RTRIM(@Ten_Chuc_Nang))
	set @Link_URL = LTRIM(RTRIM(@Link_URL))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))


	UPDATE tbl_Log_Import_Excel SET
		Ma_Chuc_Nang = @Ma_Chuc_Nang,
		Ten_Chuc_Nang = @Ten_Chuc_Nang,
		Link_URL = @Link_URL,
		Trang_Thai_ID = @Trang_Thai_ID,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_423_NKDN_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_423_NKDN_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Log_Nhat_Ky_Dang_Nhap SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_423_NKDN_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_423_NKDN_sp_ins_Insert]
	@Ma_Dang_Nhap nvarchar(50),
	@IP nvarchar(50),
	@User_Agent nvarchar(500),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))
	set @IP = LTRIM(RTRIM(@IP))
	set @User_Agent = LTRIM(RTRIM(@User_Agent))

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Log_Nhat_Ky_Dang_Nhap
	(
		Auto_ID,
		Ma_Dang_Nhap,
		IP,
		User_Agent,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Dang_Nhap,
		@IP,
		@User_Agent,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_423_NKDN_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_423_NKDN_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Log_Nhat_Ky_Dang_Nhap with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_423_NKDN_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_423_NKDN_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Dang_Nhap, IP, User_Agent
	FROM 
		view_Log_Nhat_Ky_Dang_Nhap with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_423_NKDN_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_423_NKDN_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_Dang_Nhap nvarchar(50),
	@IP nvarchar(50),
	@User_Agent nvarchar(500),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))
	set @IP = LTRIM(RTRIM(@IP))
	set @User_Agent = LTRIM(RTRIM(@User_Agent))

	UPDATE tbl_Log_Nhat_Ky_Dang_Nhap SET
		Ma_Dang_Nhap = @Ma_Dang_Nhap,
		IP = @IP,
		User_Agent = @User_Agent,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_424_NKTCCN_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_424_NKTCCN_sp_ins_Insert]
	@Ma_Dang_Nhap nvarchar(50),
	@Ma_Chuc_Nang nvarchar(50),
	@Ten_Chuc_Nang nvarchar(200),
	@Created_By nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))
	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Ten_Chuc_Nang = LTRIM(RTRIM(@Ten_Chuc_Nang))

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Log_Nhat_Ky_Truy_Cap_Chuc_Nang
	(
		Auto_ID,
		Ma_Dang_Nhap,
		Ma_Chuc_Nang,
		Ten_Chuc_Nang,
		deleted,
		Created,
		Created_By
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Dang_Nhap,
		@Ma_Chuc_Nang,
		@Ten_Chuc_Nang,
		0,
		getdate(),
		@Created_By
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_424_NKTCCN_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_424_NKTCCN_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Log_Nhat_Ky_Truy_Cap_Chuc_Nang with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_424_NKTCCN_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_424_NKTCCN_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Dang_Nhap, Ma_Chuc_Nang, Ten_Chuc_Nang, Created
	FROM 
		view_Log_Nhat_Ky_Truy_Cap_Chuc_Nang with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_425_RAH_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_425_RAH_sp_ins_Insert]
	@Ref_ID bigint,
	@Ten_Hanh_Dong nvarchar(30),
	@Ten_Moi_Truong nvarchar(30),
	@Ma_Chuc_Nang nvarchar(20),
	@Ten_Chuc_Nang nvarchar(200),
	@Noi_Dung_Action nvarchar(500),
	@Created_By nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Hanh_Dong = LTRIM(RTRIM(@Ten_Hanh_Dong))
	set @Ten_Moi_Truong = LTRIM(RTRIM(@Ten_Moi_Truong))
	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Ten_Chuc_Nang = LTRIM(RTRIM(@Ten_Chuc_Nang))
	set @Noi_Dung_Action = LTRIM(RTRIM(@Noi_Dung_Action))

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Log_Record_Action_History
	(
		Auto_ID,
		Ref_ID,
		Ten_Hanh_Dong,
		Ten_Moi_Truong,
		Ma_Chuc_Nang,
		Ten_Chuc_Nang,
		Noi_Dung_Action,
		deleted,
		Created,
		Created_By
	)
	VALUES
	(
		@Auto_ID,
		@Ref_ID,
		@Ten_Hanh_Dong,
		@Ten_Moi_Truong,
		@Ma_Chuc_Nang,
		@Ten_Chuc_Nang,
		@Noi_Dung_Action,
		0,
		getdate(),
		@Created_By
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_425_RAH_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_425_RAH_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Log_Record_Action_History with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_425_RAH_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_425_RAH_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ref_ID, Ten_Hanh_Dong, Ten_Moi_Truong, Ma_Chuc_Nang, Ten_Chuc_Nang, Noi_Dung_Action,
		Created, Created_By
	FROM 
		view_Log_Record_Action_History with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_427_RFE_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_427_RFE_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Log_Report_File_Excel SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_427_RFE_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_427_RFE_sp_ins_Insert]
	@Chu_Hang_ID bigint,
	@Report_File_Type_ID int,
	@Ten_File nvarchar(200),
	@File_URL nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_File = LTRIM(RTRIM(@Ten_File))
	set @File_URL = LTRIM(RTRIM(@File_URL))


	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Log_Report_File_Excel
	(
		Auto_ID,
		Chu_Hang_ID,
		Report_File_Type_ID,
		Ten_File,
		File_URL,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Chu_Hang_ID,
		@Report_File_Type_ID,
		@Ten_File,
		@File_URL,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_427_RFE_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_427_RFE_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Log_Report_File_Excel with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_427_RFE_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_427_RFE_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Chu_Hang_ID, Report_File_Type_ID, Ten_File, File_URL,
		Created_By, Created_By_Function, Created, Ma_Chu_Hang, Ten_Chu_Hang
	FROM 
		view_Log_Report_File_Excel with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_427_RFE_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_427_RFE_sp_upd_Update]
	@Auto_ID bigint,
	@Chu_Hang_ID bigint,
	@Report_File_Type_ID int,
	@Ten_File nvarchar(200),
	@File_URL nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_File = LTRIM(RTRIM(@Ten_File))
	set @File_URL = LTRIM(RTRIM(@File_URL))
	

	UPDATE tbl_Log_Report_File_Excel SET
		Chu_Hang_ID = @Chu_Hang_ID,
		Report_File_Type_ID = @Report_File_Type_ID,
		Ten_File = @Ten_File,
		File_URL = @File_URL,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_501_AS_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_501_AS_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_API_Source SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID

	UPDATE tbl_Sys_API_Source_Function SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		API_Source_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_501_AS_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_501_AS_sp_ins_Insert]
	@Ma_API_Source nvarchar(50),
	@Ten_API_Source nvarchar(200),
	@Link_API nvarchar(200),
	@User_Name nvarchar(200),
	@Password nvarchar(200),
	@Token_1 nvarchar(400),
	@Token_2 nvarchar(400),
	@Client_ID_1 nvarchar(400),
	@Client_ID_2 nvarchar(400),
	@Url_Folder_Download nvarchar(200),
	@Url_Folder_Upload nvarchar(200),
	@Url_Folder_Download_BAK nvarchar(200),
	@Url_Folder_Upload_BAK nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_API_Source = LTRIM(RTRIM(@Ma_API_Source))
	set @Ten_API_Source = LTRIM(RTRIM(@Ten_API_Source))
	set @Link_API = LTRIM(RTRIM(@Link_API))
	set @User_Name = LTRIM(RTRIM(@User_Name))
	set @Password = LTRIM(RTRIM(@Password))
	set @Token_1 = LTRIM(RTRIM(@Token_1))
	set @Token_2 = LTRIM(RTRIM(@Token_2))
	set @Client_ID_1 = LTRIM(RTRIM(@Client_ID_1))
	set @Client_ID_2 = LTRIM(RTRIM(@Client_ID_2))
	set @Url_Folder_Download = LTRIM(RTRIM(@Url_Folder_Download))
	set @Url_Folder_Upload = LTRIM(RTRIM(@Url_Folder_Upload))
	set @Url_Folder_Download_BAK = LTRIM(RTRIM(@Url_Folder_Download_BAK))
	set @Url_Folder_Upload_BAK = LTRIM(RTRIM(@Url_Folder_Upload_BAK))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_API_Source, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã API Source.', 11, 1)
		return
	end

	if (isnull(@Ten_API_Source, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên API Source.', 11, 1)
		return
	end
	

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_API_Source with (nolock) where Ma_API_Source = @Ma_API_Source)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã API Source đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_API_Source with (nolock) where Ten_API_Source = @Ten_API_Source)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên API Source đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_API_Source
	(
		Auto_ID,
		Ma_API_Source,
		Ten_API_Source,
		Link_API,
		User_Name,
		Password,
		Token_1,
		Token_2,
		Client_ID_1,
		Client_ID_2,
		Url_Folder_Download,
		Url_Folder_Upload,
		Url_Folder_Download_BAK,
		Url_Folder_Upload_BAK,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_API_Source,
		@Ten_API_Source,
		@Link_API,
		@User_Name,
		@Password,
		@Token_1,
		@Token_2,
		@Client_ID_1,
		@Client_ID_2,
		@Url_Folder_Download,
		@Url_Folder_Upload,
		@Url_Folder_Download_BAK,
		@Url_Folder_Upload_BAK,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_501_AS_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_501_AS_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_API_Source with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_501_AS_sp_sel_Get_By_Ma_API_Source]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_501_AS_sp_sel_Get_By_Ma_API_Source]
	@Ma_API_Source nvarchar(100)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_API_Source with (nolock)
	WHERE
		Ma_API_Source = @Ma_API_Source
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_501_AS_sp_sel_List]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_501_AS_sp_sel_List]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_API_Source, Ten_API_Source, Link_API, User_Name, Password, Token_1, Token_2, Client_ID_1, 
		Client_ID_2, Url_Folder_Download, Url_Folder_Upload, Url_Folder_Download_BAK, Url_Folder_Upload_BAK, Ghi_Chu,
		Created, Created_By, Last_Updated, Last_Updated_By, Last_Updated_By_Function, Created_By_Function
	FROM 
		view_Sys_API_Source with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_501_AS_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_501_AS_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_API_Source, Ten_API_Source, Link_API, User_Name, Password, Token_1, Token_2, Client_ID_1, Client_ID_2, Url_Folder_Download, Url_Folder_Upload, Url_Folder_Download_BAK, Url_Folder_Upload_BAK, Ghi_Chu
	FROM 
		view_Sys_API_Source with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_501_AS_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_501_AS_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_API_Source, Ten_API_Source, Link_API, User_Name, Password, Token_1, Token_2, Client_ID_1, 
		Client_ID_2, Url_Folder_Download, Url_Folder_Upload, Url_Folder_Download_BAK, Url_Folder_Upload_BAK, Ghi_Chu,
		Created, Created_By, Last_Updated, Last_Updated_By, Last_Updated_By_Function, Created_By_Function
	FROM 
		view_Sys_API_Source with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_501_AS_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_501_AS_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_API_Source nvarchar(50),
	@Ten_API_Source nvarchar(200),
	@Link_API nvarchar(200),
	@User_Name nvarchar(200),
	@Password nvarchar(200),
	@Token_1 nvarchar(1000),
	@Token_2 nvarchar(400),
	@Client_ID_1 nvarchar(400),
	@Client_ID_2 nvarchar(400),
	@Url_Folder_Download nvarchar(200),
	@Url_Folder_Upload nvarchar(200),
	@Url_Folder_Download_BAK nvarchar(200),
	@Url_Folder_Upload_BAK nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_API_Source = LTRIM(RTRIM(@Ma_API_Source))
	set @Ten_API_Source = LTRIM(RTRIM(@Ten_API_Source))
	set @Link_API = LTRIM(RTRIM(@Link_API))
	set @User_Name = LTRIM(RTRIM(@User_Name))
	set @Password = LTRIM(RTRIM(@Password))
	set @Token_1 = LTRIM(RTRIM(@Token_1))
	set @Token_2 = LTRIM(RTRIM(@Token_2))
	set @Client_ID_1 = LTRIM(RTRIM(@Client_ID_1))
	set @Client_ID_2 = LTRIM(RTRIM(@Client_ID_2))
	set @Url_Folder_Download = LTRIM(RTRIM(@Url_Folder_Download))
	set @Url_Folder_Upload = LTRIM(RTRIM(@Url_Folder_Upload))
	set @Url_Folder_Download_BAK = LTRIM(RTRIM(@Url_Folder_Download_BAK))
	set @Url_Folder_Upload_BAK = LTRIM(RTRIM(@Url_Folder_Upload_BAK))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_API_Source, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã API Source.', 11, 1)
		return
	end

	if (isnull(@Ten_API_Source, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên API Source.', 11, 1)
		return
	end


	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_API_Source with (nolock) where Ma_API_Source = @Ma_API_Source and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã API Source đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_API_Source with (nolock) where Ten_API_Source = @Ten_API_Source and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên API Source đã tồn tại.', 11, 1)
		return
	end	

	UPDATE tbl_Sys_API_Source SET
		Ma_API_Source = @Ma_API_Source,
		Ten_API_Source = @Ten_API_Source,
		Link_API = @Link_API,
		User_Name = @User_Name,
		Password = @Password,
		Token_1 = @Token_1,
		Token_2 = @Token_2,
		Client_ID_1 = @Client_ID_1,
		Client_ID_2 = @Client_ID_2,
		Url_Folder_Download = @Url_Folder_Download,
		Url_Folder_Upload = @Url_Folder_Upload,
		Url_Folder_Download_BAK = @Url_Folder_Download_BAK,
		Url_Folder_Upload_BAK = @Url_Folder_Upload_BAK,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_502_ASCH_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_502_ASCH_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_API_Source_Chu_Hang_Function SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		API_Source_Chu_Hang_ID = @Auto_ID

	UPDATE tbl_Sys_API_Source_Chu_Hang SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_502_ASCH_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_502_ASCH_sp_ins_Insert]
	@Chu_Hang_ID bigint,
	@API_Source_ID bigint,
	@Trang_Thai_ID int,
	@Ma_Su_Dung nvarchar(100),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Su_Dung = LTRIM(RTRIM(@Ma_Su_Dung))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn chủ hàng.', 11, 1)
		return
	end

	if (isnull(@API_Source_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn API Source ID.', 11, 1)
		return
	end

	if (isnull(@Trang_Thai_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn trạng thái.', 11, 1)
		return
	end

	if (isnull(@Ma_Su_Dung, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập mã sử dụng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_API_Source_Chu_Hang with (nolock) 
										where Chu_Hang_ID = @Chu_Hang_ID 
										and Ma_Su_Dung = @Ma_Su_Dung)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Chủ hàng này đã khai báo mã sử dụng này rồi.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_API_Source_Chu_Hang
	(
		Auto_ID,
		Chu_Hang_ID,
		API_Source_ID,
		Trang_Thai_ID,
		Ma_Su_Dung,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Chu_Hang_ID,
		@API_Source_ID,
		@Trang_Thai_ID,
		@Ma_Su_Dung,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_502_ASCH_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_502_ASCH_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_API_Source_Chu_Hang with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_502_ASCH_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_502_ASCH_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Chu_Hang_ID, API_Source_ID, Trang_Thai_ID, Ma_Su_Dung, Ghi_Chu,
		Ma_Chu_Hang, Ten_Chu_Hang, Ten_Viet_Tat, Ma_API_Source, Ten_API_Source
	FROM 
		view_Sys_API_Source_Chu_Hang with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_502_ASCH_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_502_ASCH_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Chu_Hang_ID, API_Source_ID, Trang_Thai_ID, Ma_Su_Dung, Ghi_Chu,
		Ma_Chu_Hang, Ten_Chu_Hang, Ten_Viet_Tat, Ma_API_Source, Ten_API_Source
	FROM 
		view_Sys_API_Source_Chu_Hang with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_502_ASCH_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_502_ASCH_sp_upd_Update]
	@Auto_ID bigint,
	@Chu_Hang_ID bigint,
	@API_Source_ID bigint,
	@Trang_Thai_ID int,
	@Ma_Su_Dung nvarchar(100),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Su_Dung = LTRIM(RTRIM(@Ma_Su_Dung))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn chủ hàng.', 11, 1)
		return
	end

	if (isnull(@API_Source_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn  API Source ID.', 11, 1)
		return
	end

	if (isnull(@Trang_Thai_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn trạng thái.', 11, 1)
		return
	end

	if (isnull(@Ma_Su_Dung, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập mã sử dụng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_API_Source_Chu_Hang with (nolock) 
										where Chu_Hang_ID = @Chu_Hang_ID 
										and Ma_Su_Dung = @Ma_Su_Dung
										and Auto_ID <> @Auto_ID)

	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Chủ hàng này đã khai báo mã sử dụng này rồi.', 11, 1)
		return
	end


	UPDATE tbl_Sys_API_Source_Chu_Hang SET
		Chu_Hang_ID = @Chu_Hang_ID,
		API_Source_ID = @API_Source_ID,
		Trang_Thai_ID = @Trang_Thai_ID,
		Ma_Su_Dung = @Ma_Su_Dung,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_503_ASCHF_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_503_ASCHF_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_API_Source_Chu_Hang_Function SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_503_ASCHF_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_503_ASCHF_sp_ins_Insert]
	@API_Source_Chu_Hang_ID bigint,
	@API_Source_Function_ID bigint,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_API_Source_Chu_Hang_Function
	(
		Auto_ID,
		API_Source_Chu_Hang_ID,
		API_Source_Function_ID,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@API_Source_Chu_Hang_ID,
		@API_Source_Function_ID,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_503_ASCHF_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[FQ_503_ASCHF_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_API_Source_Chu_Hang_Function with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_503_ASCHF_sp_sel_List_By_API_Source_Chu_Hang_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_503_ASCHF_sp_sel_List_By_API_Source_Chu_Hang_ID]
	@API_Source_Chu_Hang_ID bigint
	with recompile
AS
BEGIN

	SELECT Auto_ID, API_Source_Chu_Hang_ID, API_Source_Function_ID, Ghi_Chu,
		Ma_API_Function, Ten_API_Function
		
	FROM 
		view_Sys_API_Source_Chu_Hang_Function with (nolock) 
	WHERE 
		API_Source_Chu_Hang_ID = @API_Source_Chu_Hang_ID
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_503_ASCHF_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_503_ASCHF_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, API_Source_Chu_Hang_ID, API_Source_Function_ID, Ghi_Chu
	FROM 
		view_Sys_API_Source_Chu_Hang_Function with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_503_ASCHF_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_503_ASCHF_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, API_Source_Chu_Hang_ID, API_Source_Function_ID, Ma_API_Function, Ten_API_Function, Ghi_Chu
	FROM 
		view_Sys_API_Source_Chu_Hang_Function with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_503_ASCHF_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_503_ASCHF_sp_upd_Update]
	@Auto_ID bigint,
	@API_Source_Chu_Hang_ID bigint,
	@API_Source_Function_ID bigint,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	UPDATE tbl_Sys_API_Source_Chu_Hang_Function SET
		API_Source_Chu_Hang_ID = @API_Source_Chu_Hang_ID,
		API_Source_Function_ID = @API_Source_Function_ID,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_504_ASF_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_504_ASF_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_API_Source_Function SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_504_ASF_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_504_ASF_sp_ins_Insert]
	@API_Source_ID bigint,
	@Ma_API_Function nvarchar(50),
	@Ten_API_Function nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_API_Function = LTRIM(RTRIM(@Ma_API_Function))
	set @Ten_API_Function = LTRIM(RTRIM(@Ten_API_Function))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_API_Function, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã API Function.', 11, 1)
		return
	end

	if (isnull(@Ten_API_Function, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên API Function.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_API_Source_Function with (nolock) 
									where Ma_API_Function = @Ma_API_Function and API_Source_ID = @API_Source_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã API Function đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_API_Source_Function with (nolock) 
									where Ten_API_Function = @Ten_API_Function and API_Source_ID = @API_Source_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên API Function đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_API_Source_Function
	(
		Auto_ID,
		API_Source_ID,
		Ma_API_Function,
		Ten_API_Function,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@API_Source_ID,
		@Ma_API_Function,
		@Ten_API_Function,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_504_ASF_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_504_ASF_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_API_Source_Function with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_504_ASF_sp_sel_List_By_API_Source_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_504_ASF_sp_sel_List_By_API_Source_ID]
	@API_Source_ID int
	with recompile
AS
BEGIN
	SELECT Auto_ID, API_Source_ID, Ma_API_Function, Ten_API_Function, Ghi_Chu
	FROM 
		view_Sys_API_Source_Function with (nolock)
	Where
		API_Source_ID = @API_Source_ID
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_504_ASF_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_504_ASF_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, API_Source_ID, Ma_API_Function, Ten_API_Function, Ghi_Chu
	FROM 
		view_Sys_API_Source_Function with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_504_ASF_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_504_ASF_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_API_Function, Ten_API_Function, API_Source_ID, Last_Updated
	FROM 
		view_Sys_API_Source_Function with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_504_ASF_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_504_ASF_sp_upd_Update]
	@Auto_ID bigint,
	@API_Source_ID bigint,
	@Ma_API_Function nvarchar(50),
	@Ten_API_Function nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_API_Function = LTRIM(RTRIM(@Ma_API_Function))
	set @Ten_API_Function = LTRIM(RTRIM(@Ten_API_Function))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_API_Function, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã API Function.', 11, 1)
		return
	end

	if (isnull(@Ten_API_Function, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên API Function.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_API_Source_Function with (nolock) 
									where Ma_API_Function = @Ma_API_Function and API_Source_ID = @API_Source_ID and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã API Function đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_API_Source_Function with (nolock) 
									where Ten_API_Function = @Ten_API_Function and API_Source_ID = @API_Source_ID and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên API Function đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_API_Source_Function SET
		API_Source_ID = @API_Source_ID,
		Ma_API_Function = @Ma_API_Function,
		Ten_API_Function = @Ten_API_Function,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_505_AT_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_505_AT_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Auto_Thread SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_505_AT_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_505_AT_sp_ins_Insert]
	@Thread_Type_ID int,
	@Delay_Second int,
	@STT_Thread_ID int,
	@Ma_Su_Dung nvarchar(100),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Thread_Type_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn loại Thread.', 11, 1)
		return
	end

	if (isnull(@STT_Thread_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn nhóm Thread.', 11, 1)
		return
	end

	declare @Check_ID_1 int = (select top 1 Auto_ID from view_Sys_Auto_Thread with (nolock)
									where Thread_Type_ID = @Thread_Type_ID and STT_Thread_ID = @STT_Thread_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Threath này đã khai báo.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Auto_Thread
	(
		Auto_ID,
		Thread_Type_ID,
		Delay_Second,
		STT_Thread_ID,
		Ma_Su_Dung,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Thread_Type_ID,
		@Delay_Second,
		@STT_Thread_ID,
		@Ma_Su_Dung,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_505_AT_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_505_AT_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Auto_Thread with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_505_AT_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_505_AT_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Thread_Type_ID, Delay_Second, STT_Thread_ID, Ma_Su_Dung, Ghi_Chu
	FROM 
		view_Sys_Auto_Thread with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_505_AT_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_505_AT_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Thread_Type_ID, Delay_Second, STT_Thread_ID, Ma_Su_Dung, Ghi_Chu
	FROM 
		view_Sys_Auto_Thread with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_505_AT_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_505_AT_sp_upd_Update]
	@Auto_ID bigint,
	@Thread_Type_ID int,
	@Delay_Second int,
	@STT_Thread_ID int,
	@Ma_Su_Dung nvarchar(100),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Thread_Type_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn loại Thread.', 11, 1)
		return
	end

	if (isnull(@STT_Thread_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn nhóm Thread.', 11, 1)
		return
	end

	declare @Check_ID_1 int = (select top 1 Auto_ID from view_Sys_Auto_Thread with (nolock)
									where Thread_Type_ID = @Thread_Type_ID and STT_Thread_ID = @STT_Thread_ID and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Threath này đã khai báo.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Auto_Thread SET
		Thread_Type_ID = @Thread_Type_ID,
		Delay_Second = @Delay_Second,
		STT_Thread_ID = @STT_Thread_ID,
		Ma_Su_Dung = @Ma_Su_Dung,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_506_CHCA_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_506_CHCA_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Cau_Hinh_Component_App SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_506_CHCA_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_506_CHCA_sp_ins_Insert]
	@Chu_Hang_ID bigint,
	@Component_ID int,
	@Field_Name nvarchar(50),
	@Is_View bit,
	@Notes nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Notes = LTRIM(RTRIM(@Notes))

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn chủ hàng.', 11, 1)
		return
	end

	if (isnull(@Component_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn component.', 11, 1)
		return
	end

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Cau_Hinh_Component_App with (nolock) 
									where Chu_Hang_ID = @Chu_Hang_ID 
										and Component_ID = @Component_ID 
										and Field_Name = @Field_Name)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại trong chủ hàng và component này.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Cau_Hinh_Component_App
	(
		Auto_ID,
		Chu_Hang_ID,
		Component_ID,
		Field_Name,
		Is_View,
		Notes,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Chu_Hang_ID,
		@Component_ID,
		@Field_Name,
		@Is_View,
		@Notes,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_506_CHCA_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_506_CHCA_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Cau_Hinh_Component_App with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_506_CHCA_sp_sel_List]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_506_CHCA_sp_sel_List]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Chu_Hang_ID, Component_ID, Field_Name, Is_View, Notes, Ten_Viet_Tat
	FROM 
		view_Sys_Cau_Hinh_Component_App with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_506_CHCA_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_506_CHCA_sp_sel_List_By_Created]
	@Chu_Hang_ID bigint,
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Chu_Hang_ID, Component_ID, Field_Name, Is_View, Notes, Ten_Viet_Tat
	FROM 
		view_Sys_Cau_Hinh_Component_App with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
		and Chu_Hang_ID = @Chu_Hang_ID
	ORDER BY Auto_ID DESC
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_506_CHCA_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_506_CHCA_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Chu_Hang_ID, Component_ID, Field_Name, Is_View, Last_Updated
	FROM 
		view_Sys_Cau_Hinh_Component_App with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_506_CHCA_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_506_CHCA_sp_upd_Update]
	@Auto_ID bigint,
	@Chu_Hang_ID bigint,
	@Component_ID int,
	@Field_Name nvarchar(50),
	@Is_View bit,
	@Notes nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Notes = LTRIM(RTRIM(@Notes))
	
	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn chủ hàng.', 11, 1)
		return
	end

	if (isnull(@Component_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn component.', 11, 1)
		return
	end

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Cau_Hinh_Component_App with (nolock) 
									where Chu_Hang_ID = @Chu_Hang_ID 
										and Component_ID = @Component_ID 
										and Field_Name = @Field_Name 
										and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại trong chủ hàng và component này.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Cau_Hinh_Component_App SET
		Chu_Hang_ID = @Chu_Hang_ID,
		Component_ID = @Component_ID,
		Field_Name = @Field_Name,
		Is_View = @Is_View,
		Notes = @Notes,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_507_CN_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_507_CN_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Chuc_Nang SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_507_CN_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_507_CN_sp_ins_Insert]
	@Ma_Chuc_Nang nvarchar(50),
	@Ten_Chuc_Nang nvarchar(200),
	@Sort_Priority int,
	@Chuc_Nang_Parent_ID bigint,
	@Nhom_Chuc_Nang_ID int,
	@Func_URL nvarchar(200),
	@Image_URL nvarchar(50),
	@Is_View bit,
	@Is_New bit,
	@Is_Edit bit,
	@Is_Delete bit,
	@Is_Export bit,
	@Khach_Hang_ID nvarchar(50),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Ten_Chuc_Nang = LTRIM(RTRIM(@Ten_Chuc_Nang))
	set @Func_URL = LTRIM(RTRIM(@Func_URL))
	set @Image_URL = LTRIM(RTRIM(@Image_URL))
	set @Khach_Hang_ID = LTRIM(RTRIM(@Khach_Hang_ID))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	if (isnull(@Ten_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên chức năng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Chuc_Nang with (nolock) where Ma_Chuc_Nang = @Ma_Chuc_Nang)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chức năng đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Chuc_Nang
	(
		Auto_ID,
		Ma_Chuc_Nang,
		Ten_Chuc_Nang,
		Sort_Priority,
		Chuc_Nang_Parent_ID,
		Nhom_Chuc_Nang_ID,
		Func_URL,
		Image_URL,
		Is_View,
		Is_New,
		Is_Edit,
		Is_Delete,
		Is_Export,
		Khach_Hang_ID,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Chuc_Nang,
		@Ten_Chuc_Nang,
		@Sort_Priority,
		@Chuc_Nang_Parent_ID,
		@Nhom_Chuc_Nang_ID,
		@Func_URL,
		@Image_URL,
		@Is_View,
		@Is_New,
		@Is_Edit,
		@Is_Delete,
		@Is_Export,
		@Khach_Hang_ID,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_507_CN_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_507_CN_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Chuc_Nang with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_507_CN_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_507_CN_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID, Nhom_Chuc_Nang_ID, Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete, Is_Export, Khach_Hang_ID, Ghi_Chu
	FROM 
		view_Sys_Chuc_Nang with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_507_CN_sp_sel_List_By_Nhom_Chuc_Nang_A_Parent_Func_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_507_CN_sp_sel_List_By_Nhom_Chuc_Nang_A_Parent_Func_ID]
	@Nhom_Chuc_Nang_ID int,
	@Parent_Func_ID bigint
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID, Nhom_Chuc_Nang_ID, 
		Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete, Ghi_Chu
	FROM 
		view_Sys_Chuc_Nang with (nolock) 
	WHERE 
			Nhom_Chuc_Nang_ID = @Nhom_Chuc_Nang_ID
		and isnull(Chuc_Nang_Parent_ID, 0) = @Parent_Func_ID
	ORDER BY Sort_Priority ASC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_507_CN_sp_sel_List_By_Nhom_CN_A_Parent_Func_A_Nhom_TV_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_507_CN_sp_sel_List_By_Nhom_CN_A_Parent_Func_A_Nhom_TV_ID]
	@Nhom_Chuc_Nang_ID int,
	@Parent_Func_ID bigint,
	@Nhom_Thanh_Vien_ID bigint
	with recompile
AS
BEGIN
	select Chuc_Nang_ID, Is_Have_View_Permission, Is_Have_Add_Permission, Is_Have_Edit_Permission, 
		Is_Have_Delete_Permission, Is_Have_Export_Permission
	into #Temp_Phan_Quyen_7262
	from 
		view_Sys_Phan_Quyen_Chuc_Nang with (nolock) 
	where
		Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID

	SELECT A.Auto_ID, A.Ma_Chuc_Nang, A.Ten_Chuc_Nang, A.Sort_Priority, A.Chuc_Nang_Parent_ID, A.Nhom_Chuc_Nang_ID, 
		A.Func_URL, A.Image_URL, A.Is_View, A.Is_New, A.Is_Edit, A.Is_Delete, A.Is_Export, A.Ghi_Chu, B.Is_Have_View_Permission,
		B.Is_Have_Add_Permission, B.Is_Have_Edit_Permission, B.Is_Have_Delete_Permission, B.Is_Have_Export_Permission
	FROM 
		view_Sys_Chuc_Nang A with (nolock) left join #Temp_Phan_Quyen_7262 B on (A.Auto_ID = B.Chuc_Nang_ID)
	WHERE 
		A.Nhom_Chuc_Nang_ID = @Nhom_Chuc_Nang_ID
		and isnull(A.Chuc_Nang_Parent_ID, 0) = @Parent_Func_ID
	ORDER BY Sort_Priority ASC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_507_CN_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_507_CN_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_Chuc_Nang, Ten_Chuc_Nang, Sort_Priority, Chuc_Nang_Parent_ID, Nhom_Chuc_Nang_ID,
		Func_URL, Image_URL, Is_View, Is_New, Is_Edit, Is_Delete, Is_Export, Khach_Hang_ID, Last_Updated
	FROM 
		view_Sys_Chuc_Nang with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_507_CN_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_507_CN_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_Chuc_Nang nvarchar(50),
	@Ten_Chuc_Nang nvarchar(200),
	@Sort_Priority int,
	@Chuc_Nang_Parent_ID bigint,
	@Nhom_Chuc_Nang_ID int,
	@Func_URL nvarchar(200),
	@Image_URL nvarchar(50),
	@Is_View bit,
	@Is_New bit,
	@Is_Edit bit,
	@Is_Delete bit,
	@Is_Export bit,
	@Khach_Hang_ID nvarchar(50),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Ten_Chuc_Nang = LTRIM(RTRIM(@Ten_Chuc_Nang))
	set @Func_URL = LTRIM(RTRIM(@Func_URL))
	set @Image_URL = LTRIM(RTRIM(@Image_URL))
	set @Khach_Hang_ID = LTRIM(RTRIM(@Khach_Hang_ID))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	if (isnull(@Ten_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên chức năng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Chuc_Nang with (nolock) where Ma_Chuc_Nang = @Ma_Chuc_Nang and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chức năng đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Chuc_Nang SET
		Ma_Chuc_Nang = @Ma_Chuc_Nang,
		Ten_Chuc_Nang = @Ten_Chuc_Nang,
		Sort_Priority = @Sort_Priority,
		Chuc_Nang_Parent_ID = @Chuc_Nang_Parent_ID,
		Nhom_Chuc_Nang_ID = @Nhom_Chuc_Nang_ID,
		Func_URL = @Func_URL,
		Image_URL = @Image_URL,
		Is_View = @Is_View,
		Is_New = @Is_New,
		Is_Edit = @Is_Edit,
		Is_Delete = @Is_Delete,
		Is_Export = @Is_Export,
		Khach_Hang_ID = @Khach_Hang_ID,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_508_CNA_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_508_CNA_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Chuc_Nang_App SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_508_CNA_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_508_CNA_sp_ins_Insert]
	@Nhom_PDA_ID bigint,
	@FApp_M01_ID int,
	@FApp_M01_Label nvarchar(200),
	@FApp_M02_ID int,
	@FApp_M02_Label nvarchar(200),
	@FApp_M03_ID int,
	@FApp_M03_Label nvarchar(200),
	@FApp_M04_ID int,
	@FApp_M04_Label nvarchar(200),
	@FApp_M05_ID int,
	@FApp_M05_Label nvarchar(200),
	@FApp_M06_ID int,
	@FApp_M06_Label nvarchar(200),
	@FApp_M07_ID int,
	@FApp_M07_Label nvarchar(200),
	@FApp_M08_ID int,
	@FApp_M08_Label nvarchar(200),
	@FApp_M09_ID int,
	@FApp_M09_Label nvarchar(200),
	@FApp_M10_ID int,
	@FApp_M10_Label nvarchar(200),
	@FApp_M11_ID int,
	@FApp_M11_Label nvarchar(200),
	@FApp_M12_ID int,
	@FApp_M12_Label nvarchar(200),
	@FApp_M13_ID int,
	@FApp_M13_Label nvarchar(200),
	@FApp_M14_ID int,
	@FApp_M14_Label nvarchar(200),
	@FApp_M15_ID int,
	@FApp_M15_Label nvarchar(200),
	@FApp_M16_ID int,
	@FApp_M16_Label nvarchar(200),
	@FApp_M17_ID int,
	@FApp_M17_Label nvarchar(200),
	@FApp_M18_ID int,
	@FApp_M18_Label nvarchar(200),
	@FApp_M19_ID int,
	@FApp_M19_Label nvarchar(200),
	@FApp_M20_ID int,
	@FApp_M20_Label nvarchar(200),
	@FApp_M21_ID int,
	@FApp_M21_Label nvarchar(200),
	@FApp_M22_ID int,
	@FApp_M22_Label nvarchar(200),
	@FApp_M23_ID int,
	@FApp_M23_Label nvarchar(200),
	@FApp_M24_ID int,
	@FApp_M24_Label nvarchar(200),
	@FApp_M25_ID int,
	@FApp_M25_Label nvarchar(200),
	@FApp_M26_ID int,
	@FApp_M26_Label nvarchar(200),
	@FApp_M27_ID int,
	@FApp_M27_Label nvarchar(200),
	@FApp_M28_ID int,
	@FApp_M28_Label nvarchar(200),
	@FApp_M29_ID int,
	@FApp_M29_Label nvarchar(200),
	@FApp_M30_ID int,
	@FApp_M30_Label nvarchar(200),
	@FApp_M31_ID int,
	@FApp_M31_Label nvarchar(200),
	@FApp_M32_ID int,
	@FApp_M32_Label nvarchar(200),
	@FApp_M33_ID int,
	@FApp_M33_Label nvarchar(200),
	@FApp_M34_ID int,
	@FApp_M34_Label nvarchar(200),
	@FApp_M35_ID int,
	@FApp_M35_Label nvarchar(200),
	@FApp_M36_ID int,
	@FApp_M36_Label nvarchar(200),
	@FApp_M37_ID int,
	@FApp_M37_Label nvarchar(200),
	@FApp_M38_ID int,
	@FApp_M38_Label nvarchar(200),
	@FApp_M39_ID int,
	@FApp_M39_Label nvarchar(200),
	@FApp_M40_ID int,
	@FApp_M40_Label nvarchar(200),
	@FApp_M41_ID int,
	@FApp_M41_Label nvarchar(200),
	@FApp_M42_ID int,
	@FApp_M42_Label nvarchar(200),
	@FApp_M43_ID int,
	@FApp_M43_Label nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @FApp_M01_Label = LTRIM(RTRIM(@FApp_M01_Label))
	set @FApp_M02_Label = LTRIM(RTRIM(@FApp_M02_Label))
	set @FApp_M03_Label = LTRIM(RTRIM(@FApp_M03_Label))
	set @FApp_M04_Label = LTRIM(RTRIM(@FApp_M04_Label))
	set @FApp_M05_Label = LTRIM(RTRIM(@FApp_M05_Label))
	set @FApp_M06_Label = LTRIM(RTRIM(@FApp_M06_Label))
	set @FApp_M07_Label = LTRIM(RTRIM(@FApp_M07_Label))
	set @FApp_M08_Label = LTRIM(RTRIM(@FApp_M08_Label))
	set @FApp_M09_Label = LTRIM(RTRIM(@FApp_M09_Label))
	set @FApp_M10_Label = LTRIM(RTRIM(@FApp_M10_Label))
	set @FApp_M11_Label = LTRIM(RTRIM(@FApp_M11_Label))
	set @FApp_M12_Label = LTRIM(RTRIM(@FApp_M12_Label))
	set @FApp_M13_Label = LTRIM(RTRIM(@FApp_M13_Label))
	set @FApp_M14_Label = LTRIM(RTRIM(@FApp_M14_Label))
	set @FApp_M15_Label = LTRIM(RTRIM(@FApp_M15_Label))
	set @FApp_M16_Label = LTRIM(RTRIM(@FApp_M16_Label))
	set @FApp_M17_Label = LTRIM(RTRIM(@FApp_M17_Label))
	set @FApp_M18_Label = LTRIM(RTRIM(@FApp_M18_Label))
	set @FApp_M19_Label = LTRIM(RTRIM(@FApp_M19_Label))
	set @FApp_M20_Label = LTRIM(RTRIM(@FApp_M20_Label))
	set @FApp_M21_Label = LTRIM(RTRIM(@FApp_M21_Label))
	set @FApp_M22_Label = LTRIM(RTRIM(@FApp_M22_Label))
	set @FApp_M23_Label = LTRIM(RTRIM(@FApp_M23_Label))
	set @FApp_M24_Label = LTRIM(RTRIM(@FApp_M24_Label))
	set @FApp_M25_Label = LTRIM(RTRIM(@FApp_M25_Label))
	set @FApp_M26_Label = LTRIM(RTRIM(@FApp_M26_Label))
	set @FApp_M27_Label = LTRIM(RTRIM(@FApp_M27_Label))
	set @FApp_M28_Label = LTRIM(RTRIM(@FApp_M28_Label))
	set @FApp_M29_Label = LTRIM(RTRIM(@FApp_M29_Label))
	set @FApp_M30_Label = LTRIM(RTRIM(@FApp_M30_Label))
	set @FApp_M31_Label = LTRIM(RTRIM(@FApp_M31_Label))
	set @FApp_M32_Label = LTRIM(RTRIM(@FApp_M32_Label))
	set @FApp_M33_Label = LTRIM(RTRIM(@FApp_M33_Label))
	set @FApp_M34_Label = LTRIM(RTRIM(@FApp_M34_Label))
	set @FApp_M35_Label = LTRIM(RTRIM(@FApp_M35_Label))
	set @FApp_M36_Label = LTRIM(RTRIM(@FApp_M36_Label))
	set @FApp_M37_Label = LTRIM(RTRIM(@FApp_M37_Label))
	set @FApp_M38_Label = LTRIM(RTRIM(@FApp_M38_Label))
	set @FApp_M39_Label = LTRIM(RTRIM(@FApp_M39_Label))
	set @FApp_M40_Label = LTRIM(RTRIM(@FApp_M40_Label))
	set @FApp_M41_Label = LTRIM(RTRIM(@FApp_M41_Label))
	set @FApp_M42_Label = LTRIM(RTRIM(@FApp_M42_Label))
	set @FApp_M43_Label = LTRIM(RTRIM(@FApp_M43_Label))


	if (isnull(@Nhom_PDA_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn nhóm PDA.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Chuc_Nang_App with (nolock) where Nhom_PDA_ID = @Nhom_PDA_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Nhóm PDA này đã khai báo.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Chuc_Nang_App
	(
		Auto_ID,
		Nhom_PDA_ID,
		FApp_M01_ID,
		FApp_M01_Label,
		FApp_M02_ID,
		FApp_M02_Label,
		FApp_M03_ID,
		FApp_M03_Label,
		FApp_M04_ID,
		FApp_M04_Label,
		FApp_M05_ID,
		FApp_M05_Label,
		FApp_M06_ID,
		FApp_M06_Label,
		FApp_M07_ID,
		FApp_M07_Label,
		FApp_M08_ID,
		FApp_M08_Label,
		FApp_M09_ID,
		FApp_M09_Label,
		FApp_M10_ID,
		FApp_M10_Label,
		FApp_M11_ID,
		FApp_M11_Label,
		FApp_M12_ID,
		FApp_M12_Label,
		FApp_M13_ID,
		FApp_M13_Label,
		FApp_M14_ID,
		FApp_M14_Label,
		FApp_M15_ID,
		FApp_M15_Label,
		FApp_M16_ID,
		FApp_M16_Label,
		FApp_M17_ID,
		FApp_M17_Label,
		FApp_M18_ID,
		FApp_M18_Label,
		FApp_M19_ID,
		FApp_M19_Label,
		FApp_M20_ID,
		FApp_M20_Label,
		FApp_M21_ID,
		FApp_M21_Label,
		FApp_M22_ID,
		FApp_M22_Label,
		FApp_M23_ID,
		FApp_M23_Label,
		FApp_M24_ID,
		FApp_M24_Label,
		FApp_M25_ID,
		FApp_M25_Label,
		FApp_M26_ID,
		FApp_M26_Label,
		FApp_M27_ID,
		FApp_M27_Label,
		FApp_M28_ID,
		FApp_M28_Label,
		FApp_M29_ID,
		FApp_M29_Label,
		FApp_M30_ID,
		FApp_M30_Label,
		FApp_M31_ID,
		FApp_M31_Label,
		FApp_M32_ID,
		FApp_M32_Label,
		FApp_M33_ID,
		FApp_M33_Label,
		FApp_M34_ID,
		FApp_M34_Label,
		FApp_M35_ID,
		FApp_M35_Label,
		FApp_M36_ID,
		FApp_M36_Label,
		FApp_M37_ID,
		FApp_M37_Label,
		FApp_M38_ID,
		FApp_M38_Label,
		FApp_M39_ID,
		FApp_M39_Label,
		FApp_M40_ID,
		FApp_M40_Label,
		FApp_M41_ID,
		FApp_M41_Label,
		FApp_M42_ID,
		FApp_M42_Label,
		FApp_M43_ID,
		FApp_M43_Label,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Nhom_PDA_ID,
		@FApp_M01_ID,
		@FApp_M01_Label,
		@FApp_M02_ID,
		@FApp_M02_Label,
		@FApp_M03_ID,
		@FApp_M03_Label,
		@FApp_M04_ID,
		@FApp_M04_Label,
		@FApp_M05_ID,
		@FApp_M05_Label,
		@FApp_M06_ID,
		@FApp_M06_Label,
		@FApp_M07_ID,
		@FApp_M07_Label,
		@FApp_M08_ID,
		@FApp_M08_Label,
		@FApp_M09_ID,
		@FApp_M09_Label,
		@FApp_M10_ID,
		@FApp_M10_Label,
		@FApp_M11_ID,
		@FApp_M11_Label,
		@FApp_M12_ID,
		@FApp_M12_Label,
		@FApp_M13_ID,
		@FApp_M13_Label,
		@FApp_M14_ID,
		@FApp_M14_Label,
		@FApp_M15_ID,
		@FApp_M15_Label,
		@FApp_M16_ID,
		@FApp_M16_Label,
		@FApp_M17_ID,
		@FApp_M17_Label,
		@FApp_M18_ID,
		@FApp_M18_Label,
		@FApp_M19_ID,
		@FApp_M19_Label,
		@FApp_M20_ID,
		@FApp_M20_Label,
		@FApp_M21_ID,
		@FApp_M21_Label,
		@FApp_M22_ID,
		@FApp_M22_Label,
		@FApp_M23_ID,
		@FApp_M23_Label,
		@FApp_M24_ID,
		@FApp_M24_Label,
		@FApp_M25_ID,
		@FApp_M25_Label,
		@FApp_M26_ID,
		@FApp_M26_Label,
		@FApp_M27_ID,
		@FApp_M27_Label,
		@FApp_M28_ID,
		@FApp_M28_Label,
		@FApp_M29_ID,
		@FApp_M29_Label,
		@FApp_M30_ID,
		@FApp_M30_Label,
		@FApp_M31_ID,
		@FApp_M31_Label,
		@FApp_M32_ID,
		@FApp_M32_Label,
		@FApp_M33_ID,
		@FApp_M33_Label,
		@FApp_M34_ID,
		@FApp_M34_Label,
		@FApp_M35_ID,
		@FApp_M35_Label,
		@FApp_M36_ID,
		@FApp_M36_Label,
		@FApp_M37_ID,
		@FApp_M37_Label,
		@FApp_M38_ID,
		@FApp_M38_Label,
		@FApp_M39_ID,
		@FApp_M39_Label,
		@FApp_M40_ID,
		@FApp_M40_Label,
		@FApp_M41_ID,
		@FApp_M41_Label,
		@FApp_M42_ID,
		@FApp_M42_Label,
		@FApp_M43_ID,
		@FApp_M43_Label,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_508_CNA_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_508_CNA_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Chuc_Nang_App with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_508_CNA_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_508_CNA_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Nhom_PDA_ID, Ten_Nhom_PDA, FApp_M01_ID, FApp_M01_Label, FApp_M02_ID, FApp_M02_Label, FApp_M03_ID, FApp_M03_Label, 
		FApp_M04_ID, FApp_M04_Label, FApp_M05_ID, FApp_M05_Label, FApp_M06_ID, FApp_M06_Label, FApp_M07_ID, FApp_M07_Label, FApp_M08_ID, 
		FApp_M08_Label, FApp_M09_ID, FApp_M09_Label, FApp_M10_ID, FApp_M10_Label, FApp_M11_ID, FApp_M11_Label, FApp_M12_ID, FApp_M12_Label, 
		FApp_M13_ID, FApp_M13_Label, FApp_M14_ID, FApp_M14_Label, FApp_M15_ID, FApp_M15_Label, FApp_M16_ID, FApp_M16_Label, FApp_M17_ID, 
		FApp_M17_Label, FApp_M18_ID, FApp_M18_Label, FApp_M19_ID, FApp_M19_Label, FApp_M20_ID, FApp_M20_Label, FApp_M21_ID, FApp_M21_Label, 
		FApp_M22_ID, FApp_M22_Label, FApp_M23_ID, FApp_M23_Label, FApp_M24_ID, FApp_M24_Label, FApp_M25_ID, FApp_M25_Label, FApp_M26_ID,
		FApp_M26_Label, FApp_M27_ID, FApp_M27_Label, FApp_M28_ID, FApp_M28_Label, FApp_M29_ID, FApp_M29_Label, FApp_M30_ID, FApp_M30_Label,
		FApp_M31_ID, FApp_M31_Label, FApp_M32_ID, FApp_M32_Label, FApp_M33_ID, FApp_M33_Label, FApp_M34_ID, FApp_M34_Label, FApp_M35_ID,
		FApp_M35_Label, FApp_M36_ID, FApp_M36_Label, FApp_M37_ID, FApp_M37_Label, FApp_M38_ID, FApp_M38_Label, FApp_M39_ID, FApp_M39_Label,
		FApp_M40_ID, FApp_M40_Label, FApp_M41_ID, FApp_M41_Label, FApp_M42_ID, FApp_M42_Label, FApp_M43_ID, FApp_M43_Label
	FROM 
		view_Sys_Chuc_Nang_App with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_508_CNA_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_508_CNA_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Nhom_PDA_ID, Ten_Nhom_PDA, FApp_M01_ID, FApp_M01_Label, FApp_M02_ID, FApp_M02_Label, FApp_M03_ID, FApp_M03_Label, FApp_M04_ID, 
	FApp_M04_Label, FApp_M05_ID, FApp_M05_Label, FApp_M06_ID, FApp_M06_Label, FApp_M07_ID, FApp_M07_Label, FApp_M08_ID, 
	FApp_M08_Label, FApp_M09_ID, FApp_M09_Label, FApp_M10_ID, FApp_M10_Label, FApp_M11_ID, FApp_M11_Label, FApp_M12_ID, 
	FApp_M12_Label, FApp_M13_ID, FApp_M13_Label, FApp_M14_ID, FApp_M14_Label, FApp_M15_ID, FApp_M15_Label, FApp_M16_ID, 
	FApp_M16_Label, FApp_M17_ID, FApp_M17_Label, FApp_M18_ID, FApp_M18_Label, FApp_M19_ID, FApp_M19_Label, FApp_M20_ID, 
	FApp_M20_Label, FApp_M21_ID, FApp_M21_Label, FApp_M22_ID, FApp_M22_Label, FApp_M23_ID, FApp_M23_Label, FApp_M24_ID,
	FApp_M24_Label, FApp_M25_ID, FApp_M25_Label, FApp_M26_ID, FApp_M26_Label, FApp_M27_ID, FApp_M27_Label, FApp_M28_ID, 
	FApp_M28_Label, FApp_M29_ID, FApp_M29_Label, FApp_M30_ID, FApp_M30_Label, FApp_M31_ID, FApp_M31_Label, FApp_M32_ID, 
	FApp_M32_Label, FApp_M33_ID, FApp_M33_Label, FApp_M34_ID, FApp_M34_Label, FApp_M35_ID, FApp_M35_Label, FApp_M36_ID, 
	FApp_M36_Label, FApp_M37_ID, FApp_M37_Label, FApp_M38_ID, FApp_M38_Label, FApp_M39_ID, FApp_M39_Label, FApp_M40_ID, 
	FApp_M40_Label, FApp_M41_ID, FApp_M41_Label, FApp_M42_ID, FApp_M42_Label, FApp_M43_ID, FApp_M43_Label
	FROM 
		view_Sys_Chuc_Nang_App with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_508_CNA_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_508_CNA_sp_upd_Update]
	@Auto_ID bigint,
	@Nhom_PDA_ID bigint,
	@FApp_M01_ID int,
	@FApp_M01_Label nvarchar(200),
	@FApp_M02_ID int,
	@FApp_M02_Label nvarchar(200),
	@FApp_M03_ID int,
	@FApp_M03_Label nvarchar(200),
	@FApp_M04_ID int,
	@FApp_M04_Label nvarchar(200),
	@FApp_M05_ID int,
	@FApp_M05_Label nvarchar(200),
	@FApp_M06_ID int,
	@FApp_M06_Label nvarchar(200),
	@FApp_M07_ID int,
	@FApp_M07_Label nvarchar(200),
	@FApp_M08_ID int,
	@FApp_M08_Label nvarchar(200),
	@FApp_M09_ID int,
	@FApp_M09_Label nvarchar(200),
	@FApp_M10_ID int,
	@FApp_M10_Label nvarchar(200),
	@FApp_M11_ID int,
	@FApp_M11_Label nvarchar(200),
	@FApp_M12_ID int,
	@FApp_M12_Label nvarchar(200),
	@FApp_M13_ID int,
	@FApp_M13_Label nvarchar(200),
	@FApp_M14_ID int,
	@FApp_M14_Label nvarchar(200),
	@FApp_M15_ID int,
	@FApp_M15_Label nvarchar(200),
	@FApp_M16_ID int,
	@FApp_M16_Label nvarchar(200),
	@FApp_M17_ID int,
	@FApp_M17_Label nvarchar(200),
	@FApp_M18_ID int,
	@FApp_M18_Label nvarchar(200),
	@FApp_M19_ID int,
	@FApp_M19_Label nvarchar(200),
	@FApp_M20_ID int,
	@FApp_M20_Label nvarchar(200),
	@FApp_M21_ID int,
	@FApp_M21_Label nvarchar(200),
	@FApp_M22_ID int,
	@FApp_M22_Label nvarchar(200),
	@FApp_M23_ID int,
	@FApp_M23_Label nvarchar(200),
	@FApp_M24_ID int,
	@FApp_M24_Label nvarchar(200),
	@FApp_M25_ID int,
	@FApp_M25_Label nvarchar(200),
	@FApp_M26_ID int,
	@FApp_M26_Label nvarchar(200),
	@FApp_M27_ID int,
	@FApp_M27_Label nvarchar(200),
	@FApp_M28_ID int,
	@FApp_M28_Label nvarchar(200),
	@FApp_M29_ID int,
	@FApp_M29_Label nvarchar(200),
	@FApp_M30_ID int,
	@FApp_M30_Label nvarchar(200),
	@FApp_M31_ID int,
	@FApp_M31_Label nvarchar(200),
	@FApp_M32_ID int,
	@FApp_M32_Label nvarchar(200),
	@FApp_M33_ID int,
	@FApp_M33_Label nvarchar(200),
	@FApp_M34_ID int,
	@FApp_M34_Label nvarchar(200),
	@FApp_M35_ID int,
	@FApp_M35_Label nvarchar(200),
	@FApp_M36_ID int,
	@FApp_M36_Label nvarchar(200),
	@FApp_M37_ID int,
	@FApp_M37_Label nvarchar(200),
	@FApp_M38_ID int,
	@FApp_M38_Label nvarchar(200),
	@FApp_M39_ID int,
	@FApp_M39_Label nvarchar(200),
	@FApp_M40_ID int,
	@FApp_M40_Label nvarchar(200),
	@FApp_M41_ID int,
	@FApp_M41_Label nvarchar(200),
	@FApp_M42_ID int,
	@FApp_M42_Label nvarchar(200),
	@FApp_M43_ID int,
	@FApp_M43_Label nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @FApp_M01_Label = LTRIM(RTRIM(@FApp_M01_Label))
	set @FApp_M02_Label = LTRIM(RTRIM(@FApp_M02_Label))
	set @FApp_M03_Label = LTRIM(RTRIM(@FApp_M03_Label))
	set @FApp_M04_Label = LTRIM(RTRIM(@FApp_M04_Label))
	set @FApp_M05_Label = LTRIM(RTRIM(@FApp_M05_Label))
	set @FApp_M06_Label = LTRIM(RTRIM(@FApp_M06_Label))
	set @FApp_M07_Label = LTRIM(RTRIM(@FApp_M07_Label))
	set @FApp_M08_Label = LTRIM(RTRIM(@FApp_M08_Label))
	set @FApp_M09_Label = LTRIM(RTRIM(@FApp_M09_Label))
	set @FApp_M10_Label = LTRIM(RTRIM(@FApp_M10_Label))
	set @FApp_M11_Label = LTRIM(RTRIM(@FApp_M11_Label))
	set @FApp_M12_Label = LTRIM(RTRIM(@FApp_M12_Label))
	set @FApp_M13_Label = LTRIM(RTRIM(@FApp_M13_Label))
	set @FApp_M14_Label = LTRIM(RTRIM(@FApp_M14_Label))
	set @FApp_M15_Label = LTRIM(RTRIM(@FApp_M15_Label))
	set @FApp_M16_Label = LTRIM(RTRIM(@FApp_M16_Label))
	set @FApp_M17_Label = LTRIM(RTRIM(@FApp_M17_Label))
	set @FApp_M18_Label = LTRIM(RTRIM(@FApp_M18_Label))
	set @FApp_M19_Label = LTRIM(RTRIM(@FApp_M19_Label))
	set @FApp_M20_Label = LTRIM(RTRIM(@FApp_M20_Label))
	set @FApp_M21_Label = LTRIM(RTRIM(@FApp_M21_Label))
	set @FApp_M22_Label = LTRIM(RTRIM(@FApp_M22_Label))
	set @FApp_M23_Label = LTRIM(RTRIM(@FApp_M23_Label))
	set @FApp_M24_Label = LTRIM(RTRIM(@FApp_M24_Label))
	set @FApp_M25_Label = LTRIM(RTRIM(@FApp_M25_Label))
	set @FApp_M26_Label = LTRIM(RTRIM(@FApp_M26_Label))
	set @FApp_M27_Label = LTRIM(RTRIM(@FApp_M27_Label))
	set @FApp_M28_Label = LTRIM(RTRIM(@FApp_M28_Label))
	set @FApp_M29_Label = LTRIM(RTRIM(@FApp_M29_Label))
	set @FApp_M30_Label = LTRIM(RTRIM(@FApp_M30_Label))
	set @FApp_M31_Label = LTRIM(RTRIM(@FApp_M31_Label))
	set @FApp_M32_Label = LTRIM(RTRIM(@FApp_M32_Label))
	set @FApp_M33_Label = LTRIM(RTRIM(@FApp_M33_Label))
	set @FApp_M34_Label = LTRIM(RTRIM(@FApp_M34_Label))
	set @FApp_M35_Label = LTRIM(RTRIM(@FApp_M35_Label))
	set @FApp_M36_Label = LTRIM(RTRIM(@FApp_M36_Label))
	set @FApp_M37_Label = LTRIM(RTRIM(@FApp_M37_Label))
	set @FApp_M38_Label = LTRIM(RTRIM(@FApp_M38_Label))
	set @FApp_M39_Label = LTRIM(RTRIM(@FApp_M39_Label))
	set @FApp_M40_Label = LTRIM(RTRIM(@FApp_M40_Label))
	set @FApp_M41_Label = LTRIM(RTRIM(@FApp_M41_Label))
	set @FApp_M42_Label = LTRIM(RTRIM(@FApp_M42_Label))
	set @FApp_M43_Label = LTRIM(RTRIM(@FApp_M43_Label))

	if (isnull(@Nhom_PDA_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn nhóm PDA.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Chuc_Nang_App with (nolock) where Nhom_PDA_ID = @Nhom_PDA_ID and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Nhóm PDA này đã khai báo.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Chuc_Nang_App SET
		Nhom_PDA_ID = @Nhom_PDA_ID,
		FApp_M01_ID = @FApp_M01_ID,
		FApp_M01_Label = @FApp_M01_Label,
		FApp_M02_ID = @FApp_M02_ID,
		FApp_M02_Label = @FApp_M02_Label,
		FApp_M03_ID = @FApp_M03_ID,
		FApp_M03_Label = @FApp_M03_Label,
		FApp_M04_ID = @FApp_M04_ID,
		FApp_M04_Label = @FApp_M04_Label,
		FApp_M05_ID = @FApp_M05_ID,
		FApp_M05_Label = @FApp_M05_Label,
		FApp_M06_ID = @FApp_M06_ID,
		FApp_M06_Label = @FApp_M06_Label,
		FApp_M07_ID = @FApp_M07_ID,
		FApp_M07_Label = @FApp_M07_Label,
		FApp_M08_ID = @FApp_M08_ID,
		FApp_M08_Label = @FApp_M08_Label,
		FApp_M09_ID = @FApp_M09_ID,
		FApp_M09_Label = @FApp_M09_Label,
		FApp_M10_ID = @FApp_M10_ID,
		FApp_M10_Label = @FApp_M10_Label,
		FApp_M11_ID = @FApp_M11_ID,
		FApp_M11_Label = @FApp_M11_Label,
		FApp_M12_ID = @FApp_M12_ID,
		FApp_M12_Label = @FApp_M12_Label,
		FApp_M13_ID = @FApp_M13_ID,
		FApp_M13_Label = @FApp_M13_Label,
		FApp_M14_ID = @FApp_M14_ID,
		FApp_M14_Label = @FApp_M14_Label,
		FApp_M15_ID = @FApp_M15_ID,
		FApp_M15_Label = @FApp_M15_Label,
		FApp_M16_ID = @FApp_M16_ID,
		FApp_M16_Label = @FApp_M16_Label,
		FApp_M17_ID = @FApp_M17_ID,
		FApp_M17_Label = @FApp_M17_Label,
		FApp_M18_ID = @FApp_M18_ID,
		FApp_M18_Label = @FApp_M18_Label,
		FApp_M19_ID = @FApp_M19_ID,
		FApp_M19_Label = @FApp_M19_Label,
		FApp_M20_ID = @FApp_M20_ID,
		FApp_M20_Label = @FApp_M20_Label,
		FApp_M21_ID = @FApp_M21_ID,
		FApp_M21_Label = @FApp_M21_Label,
		FApp_M22_ID = @FApp_M22_ID,
		FApp_M22_Label = @FApp_M22_Label,
		FApp_M23_ID = @FApp_M23_ID,
		FApp_M23_Label = @FApp_M23_Label,
		FApp_M24_ID = @FApp_M24_ID,
		FApp_M24_Label = @FApp_M24_Label,
		FApp_M25_ID = @FApp_M25_ID,
		FApp_M25_Label = @FApp_M25_Label,
		FApp_M26_ID = @FApp_M26_ID,
		FApp_M26_Label = @FApp_M26_Label,
		FApp_M27_ID = @FApp_M27_ID,
		FApp_M27_Label = @FApp_M27_Label,
		FApp_M28_ID = @FApp_M28_ID,
		FApp_M28_Label = @FApp_M28_Label,
		FApp_M29_ID = @FApp_M29_ID,
		FApp_M29_Label = @FApp_M29_Label,
		FApp_M30_ID = @FApp_M30_ID,
		FApp_M30_Label = @FApp_M30_Label,
		FApp_M31_ID = @FApp_M31_ID,
		FApp_M31_Label = @FApp_M31_Label,
		FApp_M32_ID = @FApp_M32_ID,
		FApp_M32_Label = @FApp_M32_Label,
		FApp_M33_ID = @FApp_M33_ID,
		FApp_M33_Label = @FApp_M33_Label,
		FApp_M34_ID = @FApp_M34_ID,
		FApp_M34_Label = @FApp_M34_Label,
		FApp_M35_ID = @FApp_M35_ID,
		FApp_M35_Label = @FApp_M35_Label,
		FApp_M36_ID = @FApp_M36_ID,
		FApp_M36_Label = @FApp_M36_Label,
		FApp_M37_ID = @FApp_M37_ID,
		FApp_M37_Label = @FApp_M37_Label,
		FApp_M38_ID = @FApp_M38_ID,
		FApp_M38_Label = @FApp_M38_Label,
		FApp_M39_ID = @FApp_M39_ID,
		FApp_M39_Label = @FApp_M39_Label,
		FApp_M40_ID = @FApp_M40_ID,
		FApp_M40_Label = @FApp_M40_Label,
		FApp_M41_ID = @FApp_M41_ID,
		FApp_M41_Label = @FApp_M41_Label,
		FApp_M42_ID = @FApp_M42_ID,
		FApp_M42_Label = @FApp_M42_Label,
		FApp_M43_ID = @FApp_M43_ID,
		FApp_M43_Label = @FApp_M43_Label,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_509_CW_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_509_CW_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Column_Width SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_509_CW_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_509_CW_sp_ins_Insert]
	@Field_Name nvarchar(50),
	@Do_Rong int,
	@Format_Number nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Format_Number = LTRIM(RTRIM(@Format_Number))

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Column_Width with (nolock) where Field_Name = @Field_Name)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Column_Width
	(
		Auto_ID,
		Field_Name,
		Do_Rong,
		Format_Number,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Field_Name,
		@Do_Rong,
		@Format_Number,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_509_CW_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_509_CW_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Column_Width with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_509_CW_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_509_CW_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Field_Name, Do_Rong, Format_Number
	FROM 
		view_Sys_Column_Width with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_509_CW_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_509_CW_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Field_Name, Do_Rong, Format_Number, Last_Updated
	FROM 
		view_Sys_Column_Width with (nolock)
	order by Field_Name ASC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_509_CW_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_509_CW_sp_upd_Update]
	@Auto_ID bigint,
	@Field_Name nvarchar(50),
	@Do_Rong int,
	@Format_Number nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Format_Number = LTRIM(RTRIM(@Format_Number))

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Column_Width with (nolock) where Field_Name = @Field_Name and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Column_Width SET
		Field_Name = @Field_Name,
		Do_Rong = @Do_Rong,
		Format_Number = @Format_Number,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_510_DSJ_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_510_DSJ_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Daily_Schedule_Job SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_510_DSJ_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_510_DSJ_sp_ins_Insert]
	@Chu_Hang_ID bigint,
	@Ngay_Gio_Xu_Ly datetime,
	@Schedule_Job_ID int,
	@Email_Nhan nvarchar(2000),
	@Trang_Thai_ID int,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Email_Nhan = LTRIM(RTRIM(@Email_Nhan))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	set @Ngay_Gio_Xu_Ly = dbo.fnConvert_Ngay_To_NULL(@Ngay_Gio_Xu_Ly)

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn Chủ Hàng.', 11, 1)
		return
	end

	if (isnull(@Ngay_Gio_Xu_Ly, '') = '')
	begin
		RAISERROR(N'Vui lòng chọn Giờ Xử Lý.', 11, 1)
		return
	end

	if (isnull(@Schedule_Job_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn Job.', 11, 1)
		return
	end

	if (isnull(@Trang_Thai_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn Trạng Thái.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Daily_Schedule_Job
	(
		Auto_ID,
		Chu_Hang_ID,
		Ngay_Gio_Xu_Ly,
		Schedule_Job_ID,
		Email_Nhan,
		Trang_Thai_ID,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Chu_Hang_ID,
		@Ngay_Gio_Xu_Ly,
		@Schedule_Job_ID,
		@Email_Nhan,
		@Trang_Thai_ID,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_510_DSJ_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_510_DSJ_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Daily_Schedule_Job with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_510_DSJ_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_510_DSJ_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Chu_Hang_ID, Ngay_Gio_Xu_Ly, Schedule_Job_ID, Email_Nhan, Trang_Thai_ID, Ghi_Chu,
		Ma_Chu_Hang, Ten_Chu_Hang, Ten_Viet_Tat
	FROM 
		view_Sys_Daily_Schedule_Job with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_510_DSJ_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_510_DSJ_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Chu_Hang_ID, Ngay_Gio_Xu_Ly, Schedule_Job_ID, Email_Nhan, Trang_Thai_ID, Ghi_Chu, Last_Updated
	FROM 
		view_Sys_Daily_Schedule_Job with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_510_DSJ_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_510_DSJ_sp_upd_Update]
	@Auto_ID bigint,
	@Chu_Hang_ID bigint,
	@Ngay_Gio_Xu_Ly datetime,
	@Schedule_Job_ID int,
	@Email_Nhan nvarchar(2000),
	@Trang_Thai_ID int,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Email_Nhan = LTRIM(RTRIM(@Email_Nhan))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	set @Ngay_Gio_Xu_Ly = dbo.fnConvert_Ngay_To_NULL(@Ngay_Gio_Xu_Ly)

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn Chủ Hàng.', 11, 1)
		return
	end

	if (isnull(@Ngay_Gio_Xu_Ly, '') = '')
	begin
		RAISERROR(N'Vui lòng chọn Giờ Xử Lý.', 11, 1)
		return
	end

	if (isnull(@Schedule_Job_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn Job.', 11, 1)
		return
	end

	if (isnull(@Trang_Thai_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn Trạng Thái.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Daily_Schedule_Job SET
		Chu_Hang_ID = @Chu_Hang_ID,
		Ngay_Gio_Xu_Ly = @Ngay_Gio_Xu_Ly,
		Schedule_Job_ID = @Schedule_Job_ID,
		Email_Nhan = @Email_Nhan,
		Trang_Thai_ID = @Trang_Thai_ID,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_511_DD_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_511_DD_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Drill_Down SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_511_DD_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_511_DD_sp_ins_Insert]
	@Field_Name nvarchar(50),
	@Link_URL nvarchar(200),
	@Parameter_Field nvarchar(50),
	@Func_ID nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Link_URL = LTRIM(RTRIM(@Link_URL))
	set @Parameter_Field = LTRIM(RTRIM(@Parameter_Field))
	set @Func_ID = LTRIM(RTRIM(@Func_ID))

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Drill_Down with (nolock) where Field_Name = @Field_Name)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Drill_Down
	(
		Auto_ID,
		Field_Name,
		Link_URL,
		Parameter_Field,
		Func_ID,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Field_Name,
		@Link_URL,
		@Parameter_Field,
		@Func_ID,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_511_DD_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_511_DD_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Drill_Down with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_511_DD_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_511_DD_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Field_Name, Link_URL, Parameter_Field, Func_ID
	FROM 
		view_Sys_Drill_Down with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_511_DD_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_511_DD_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Field_Name, Link_URL, Parameter_Field, Func_ID, Last_Updated
	FROM 
		view_Sys_Drill_Down with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_511_DD_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_511_DD_sp_upd_Update]
	@Auto_ID bigint,
	@Field_Name nvarchar(50),
	@Link_URL nvarchar(200),
	@Parameter_Field nvarchar(50),
	@Func_ID nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Link_URL = LTRIM(RTRIM(@Link_URL))
	set @Parameter_Field = LTRIM(RTRIM(@Parameter_Field))
	set @Func_ID = LTRIM(RTRIM(@Func_ID))

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Drill_Down with (nolock) where Field_Name = @Field_Name and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Drill_Down SET
		Field_Name = @Field_Name,
		Link_URL = @Link_URL,
		Parameter_Field = @Parameter_Field,
		Func_ID = @Func_ID,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_512_FDD_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_512_FDD_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Filter_Date_Default SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_512_FDD_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_512_FDD_sp_ins_Insert]
	@Ma_Chuc_Nang nvarchar(50),
	@Duration_Days_From float,
	@Duration_Days_To float,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Filter_Date_Default with (nolock) where Ma_Chuc_Nang = @Ma_Chuc_Nang)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chức năng đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Filter_Date_Default
	(
		Auto_ID,
		Ma_Chuc_Nang,
		Duration_Days_From,
		Duration_Days_To,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Chuc_Nang,
		@Duration_Days_From,
		@Duration_Days_To,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_512_FDD_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_512_FDD_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Filter_Date_Default with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_512_FDD_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_512_FDD_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Chuc_Nang, Duration_Days_From, Duration_Days_To, Ghi_Chu
	FROM 
		view_Sys_Filter_Date_Default with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_512_FDD_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_512_FDD_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_Chuc_Nang, Duration_Days_From, Duration_Days_To, Last_Updated
	FROM 
		view_Sys_Filter_Date_Default with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_512_FDD_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_512_FDD_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_Chuc_Nang nvarchar(50),
	@Duration_Days_From float,
	@Duration_Days_To float,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Filter_Date_Default with (nolock) where Ma_Chuc_Nang = @Ma_Chuc_Nang and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chức năng đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Filter_Date_Default SET
		Ma_Chuc_Nang = @Ma_Chuc_Nang,
		Duration_Days_From = @Duration_Days_From,
		Duration_Days_To = @Duration_Days_To,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_513_FC_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_513_FC_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Frozen_Column SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_513_FC_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_513_FC_sp_ins_Insert]
	@Ma_Chuc_Nang nvarchar(50),
	@SL_Cot_Frozen int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Frozen_Column with (nolock) where Ma_Chuc_Nang = @Ma_Chuc_Nang)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chức năng đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Frozen_Column
	(
		Auto_ID,
		Ma_Chuc_Nang,
		SL_Cot_Frozen,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Chuc_Nang,
		@SL_Cot_Frozen,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_513_FC_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[FQ_513_FC_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Frozen_Column with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_513_FC_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_513_FC_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Chuc_Nang, SL_Cot_Frozen
	FROM 
		view_Sys_Frozen_Column with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_513_FC_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_513_FC_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_Chuc_Nang, SL_Cot_Frozen, Last_Updated
	FROM 
		view_Sys_Frozen_Column with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_513_FC_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_513_FC_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_Chuc_Nang nvarchar(50),
	@SL_Cot_Frozen int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Frozen_Column with (nolock) where Ma_Chuc_Nang = @Ma_Chuc_Nang and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chức năng đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Frozen_Column SET
		Ma_Chuc_Nang = @Ma_Chuc_Nang,
		SL_Cot_Frozen = @SL_Cot_Frozen,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_514_GF_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_514_GF_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Grid_Field SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID

	--delete luon liên kết
	UPDATE tbl_Sys_Grid_UI_Global SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Grid_Field_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_514_GF_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_514_GF_sp_ins_Insert]
	@Ten_Grid nvarchar(50),
	@Ma_Chuc_Nang nvarchar(50),
	@Field_Name nvarchar(50),
	@Tieu_De_Column nvarchar(200),
	@Column_Width int,
	@Field_Type_ID int,
	@Field_Name_Parent nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Grid = LTRIM(RTRIM(@Ten_Grid))
	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Tieu_De_Column = LTRIM(RTRIM(@Tieu_De_Column))
	set @Field_Name_Parent = LTRIM(RTRIM(@Field_Name_Parent))

	if (isnull(@Ten_Grid, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên Grid.', 11, 1)
		return
	end

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Grid_Field with (nolock) 
										where Ten_Grid = @Ten_Grid 
											and Ma_Chuc_Nang = @Ma_Chuc_Nang
											and Field_Name = @Field_Name)

	declare @Mes nvarchar(500)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		set @Mes = N'Định nghĩa cấu hình [Ten_Grid, Ma_Chuc_Nang, Field_Name ], [' + @Ten_Grid + ',' + @Ma_Chuc_Nang + ',' + @Field_Name + N'] này đã tồn tại.'
		RAISERROR(@Mes, 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Grid_Field
	(
		Auto_ID,
		Ten_Grid,
		Ma_Chuc_Nang,
		Field_Name,
		Tieu_De_Column,
		Column_Width,
		Field_Type_ID,
		Field_Name_Parent,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ten_Grid,
		@Ma_Chuc_Nang,
		@Field_Name,
		@Tieu_De_Column,
		@Column_Width,
		@Field_Type_ID,
		@Field_Name_Parent,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_514_GF_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_514_GF_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Grid_Field with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_514_GF_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_514_GF_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ten_Grid, Ma_Chuc_Nang, Field_Name, Tieu_De_Column, Column_Width, Field_Type_ID, Field_Name_Parent
	FROM 
		view_Sys_Grid_Field with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_514_GF_sp_sel_List_By_Ma_Chuc_Nang]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_514_GF_sp_sel_List_By_Ma_Chuc_Nang]
	@Ma_Chuc_Nang nvarchar(50)
	with recompile
AS
BEGIN
	SELECT A.Auto_ID, A.Ten_Grid, A.Ma_Chuc_Nang, A.Field_Name, A.Tieu_De_Column, A.Column_Width, A.Field_Type_ID,
		B.Ten_Chuc_Nang, A.Field_Name_Parent
	FROM 
		view_Sys_Grid_Field A with (nolock) 
			left join view_Sys_Chuc_Nang B with (nolock) on A.Ma_Chuc_Nang = B.Ma_Chuc_Nang
	WHERE 
			A.Ma_Chuc_Nang = @Ma_Chuc_Nang
		or ISNULL(@Ma_Chuc_Nang, '') = ''
		ORDER BY A.Ma_Chuc_Nang asc, A.Ten_Grid asc
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_514_GF_sp_sel_List_By_Ma_CN_A_Ten_Grid]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_514_GF_sp_sel_List_By_Ma_CN_A_Ten_Grid]
	@Ma_Chuc_Nang nvarchar(50),
	@Ten_Grid nvarchar(50)
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ten_Grid, Ma_Chuc_Nang, Field_Name, Tieu_De_Column, Column_Width, Field_Type_ID,
		Last_Updated, Created
	FROM 
		view_Sys_Grid_Field with (nolock) 
	WHERE 
		Ma_Chuc_Nang = @Ma_Chuc_Nang
		and Ten_Grid = @Ten_Grid
		ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_514_GF_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_514_GF_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_Chuc_Nang, Ten_Grid, Field_Name, Tieu_De_Column, Column_Width, Field_Type_ID, Last_Updated,
		Field_Name_Parent
	FROM 
		view_Sys_Grid_Field with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_514_GF_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_514_GF_sp_upd_Update]
	@Auto_ID bigint,
	@Ten_Grid nvarchar(50),
	@Ma_Chuc_Nang nvarchar(50),
	@Field_Name nvarchar(50),
	@Tieu_De_Column nvarchar(200),
	@Column_Width int,
	@Field_Type_ID int,
	@Field_Name_Parent nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Grid = LTRIM(RTRIM(@Ten_Grid))
	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Tieu_De_Column = LTRIM(RTRIM(@Tieu_De_Column))
	set @Field_Name_Parent = LTRIM(RTRIM(@Field_Name_Parent))

	if (isnull(@Ten_Grid, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập tên Grid.', 11, 1)
		return
	end

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Grid_Field with (nolock) 
										where Ten_Grid = @Ten_Grid 
											and Ma_Chuc_Nang = @Ma_Chuc_Nang
											and Field_Name = @Field_Name
											and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Tên Grid có định nghĩa này đã tồn tại đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Grid_Field SET
		Ten_Grid = @Ten_Grid,
		Ma_Chuc_Nang = @Ma_Chuc_Nang,
		Field_Name = @Field_Name,
		Tieu_De_Column = @Tieu_De_Column,
		Column_Width = @Column_Width,
		Field_Type_ID = @Field_Type_ID,
		Field_Name_Parent = @Field_Name_Parent,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_516_GUG_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_516_GUG_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Grid_UI_Global SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_516_GUG_sp_del_Delete_By_Ma_CN]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_516_GUG_sp_del_Delete_By_Ma_CN]
	@Ma_Chuc_Nang  nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Grid_UI_Global SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Ma_Chuc_Nang = @Ma_Chuc_Nang
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_516_GUG_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_516_GUG_sp_ins_Insert]
	@Ma_Chuc_Nang nvarchar(50),
	@Grid_Field_ID bigint,
	@Column_Width int,
	@Sort_Priority int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Grid_UI_Global with (nolock) 
										where Ma_Chuc_Nang = @Ma_Chuc_Nang 
											and Grid_Field_ID = @Grid_Field_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chức năng với Grid Field đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Grid_UI_Global
	(
		Auto_ID,
		Ma_Chuc_Nang,
		Grid_Field_ID,
		Column_Width,
		Sort_Priority,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Chuc_Nang,
		@Grid_Field_ID,
		@Column_Width,
		@Sort_Priority,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_516_GUG_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_516_GUG_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Grid_UI_Global with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_516_GUG_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_516_GUG_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Chuc_Nang, Grid_Field_ID, Column_Width, Sort_Priority
	FROM 
		view_Sys_Grid_UI_Global with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_516_GUG_sp_sel_List_By_Ma_CN]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_516_GUG_sp_sel_List_By_Ma_CN]
	@Ma_Chuc_Nang nvarchar(50)
	with recompile
AS
BEGIN
	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))

	SELECT Auto_ID, Ma_Chuc_Nang, Grid_Field_ID, Ten_Grid, Column_Width, Sort_Priority,
		 Tieu_De_Column, Field_Name, Field_Type_ID,
		 Last_Updated, Last_Updated_By, Created, Created_By
	FROM 
		view_Sys_Grid_UI_Global with (nolock) 
	WHERE 
		Ma_Chuc_Nang = @Ma_Chuc_Nang
	ORDER BY Sort_Priority asc
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_516_GUG_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_516_GUG_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_Chuc_Nang, Grid_Field_ID, Field_Name, Ten_Grid, Column_Width, Sort_Priority, Tieu_De_Column,
		Created, Created_By, Last_Updated, Last_Updated_By, Field_Type_ID
	FROM 
		view_Sys_Grid_UI_Global with (nolock)
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_516_GUG_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_516_GUG_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_Chuc_Nang nvarchar(50),
	@Grid_Field_ID bigint,
	@Column_Width int,
	@Sort_Priority int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Ma_Chuc_Nang.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Grid_UI_Global with (nolock) where Ma_Chuc_Nang = @Ma_Chuc_Nang and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Ma_Chuc_Nang đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Grid_UI_Global SET
		Ma_Chuc_Nang = @Ma_Chuc_Nang,
		Grid_Field_ID = @Grid_Field_ID,
		Column_Width = @Column_Width,
		Sort_Priority = @Sort_Priority,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_518_HG_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_518_HG_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Help_Guide SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_518_HG_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_518_HG_sp_ins_Insert]
	@Khach_Hang_ID int,
	@Ma_Chuc_Nang nvarchar(50),
	@Ngon_Ngu nvarchar(50),
	@Noi_Dung ntext,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Ngon_Ngu = LTRIM(RTRIM(@Ngon_Ngu))

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	if (isnull(@Ngon_Ngu, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập ngôn ngữ.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Help_Guide with (nolock) where Ma_Chuc_Nang = @Ma_Chuc_Nang and Khach_Hang_ID = @Khach_Hang_ID and Ngon_Ngu = @Ngon_Ngu)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chức năng đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Help_Guide
	(
		Auto_ID,
		Khach_Hang_ID,
		Ma_Chuc_Nang,
		Ngon_Ngu,
		Noi_Dung,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Khach_Hang_ID,
		@Ma_Chuc_Nang,
		@Ngon_Ngu,
		@Noi_Dung,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_518_HG_sp_sel_Get_By_Data]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_518_HG_sp_sel_Get_By_Data]
	@Ma_Chuc_Nang nvarchar(50),
	@Khach_Hang_ID int,
	@Ngon_Ngu nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT Auto_ID, Ma_Chuc_Nang, Noi_Dung
	from
		view_Sys_Help_Guide
	WHERE
		Ma_Chuc_Nang = @Ma_Chuc_Nang
		and Khach_Hang_ID = @Khach_Hang_ID
		and Ngon_Ngu = @Ngon_Ngu
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_518_HG_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_518_HG_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Help_Guide with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_518_HG_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_518_HG_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Khach_Hang_ID, Ma_Chuc_Nang, Ngon_Ngu
	FROM 
		view_Sys_Help_Guide with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_518_HG_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_518_HG_sp_upd_Update]
	@Auto_ID bigint,
	@Khach_Hang_ID int,
	@Ma_Chuc_Nang nvarchar(50),
	@Ngon_Ngu nvarchar(50),
	@Noi_Dung ntext,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Chuc_Nang = LTRIM(RTRIM(@Ma_Chuc_Nang))
	set @Ngon_Ngu = LTRIM(RTRIM(@Ngon_Ngu))

	if (isnull(@Ma_Chuc_Nang, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã chức năng.', 11, 1)
		return
	end

	if (isnull(@Ngon_Ngu, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập ngôn ngữ.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Help_Guide with (nolock) where Ma_Chuc_Nang = @Ma_Chuc_Nang and Khach_Hang_ID = @Khach_Hang_ID and Ngon_Ngu = @Ngon_Ngu and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã chức năng đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Help_Guide SET
		Khach_Hang_ID = @Khach_Hang_ID,
		Ma_Chuc_Nang = @Ma_Chuc_Nang,
		Ngon_Ngu = @Ngon_Ngu,
		Noi_Dung = @Noi_Dung,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_519_HAC_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_519_HAC_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Hien_An_Column SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_519_HAC_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_519_HAC_sp_ins_Insert]
	@Chu_Hang_ID bigint,
	@Field_Name nvarchar(50),
	@Option_ID int,
	@Ma_Chuc_Nang nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Hien_An_Column with (nolock) where Field_Name = @Field_Name and Ma_Chuc_Nang = @Ma_Chuc_Nang and Chu_Hang_ID = @Chu_Hang_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Hien_An_Column
	(
		Auto_ID,
		Chu_Hang_ID,
		Field_Name,
		Option_ID,
		Ma_Chuc_Nang,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Chu_Hang_ID,
		@Field_Name,
		@Option_ID,
		@Ma_Chuc_Nang,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_519_HAC_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_519_HAC_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Hien_An_Column with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_519_HAC_sp_sel_List]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_519_HAC_sp_sel_List]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Chu_Hang_ID, Field_Name, Option_ID, Ma_Chuc_Nang
	FROM 
		view_Sys_Hien_An_Column with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_519_HAC_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_519_HAC_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Chu_Hang_ID, Field_Name, Option_ID, Ma_Chuc_Nang
	FROM 
		view_Sys_Hien_An_Column with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_519_HAC_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_519_HAC_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Chu_Hang_ID, Field_Name, Option_ID, Ma_Chuc_Nang, Last_Updated
	FROM 
		view_Sys_Hien_An_Column with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_519_HAC_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_519_HAC_sp_upd_Update]
	@Auto_ID bigint,
	@Chu_Hang_ID bigint,
	@Field_Name nvarchar(50),
	@Option_ID int,
	@Ma_Chuc_Nang nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Hien_An_Column with (nolock) where Field_Name = @Field_Name and Chu_Hang_ID = @Chu_Hang_ID and Ma_Chuc_Nang = @Ma_Chuc_Nang and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Hien_An_Column SET
		Chu_Hang_ID = @Chu_Hang_ID,
		Field_Name = @Field_Name,
		Option_ID = @Option_ID,
		Ma_Chuc_Nang = @Ma_Chuc_Nang,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_520_IETC_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_520_IETC_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Import_Excel_Template_Config SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_520_IETC_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_520_IETC_sp_ins_Insert]
	@Chu_Hang_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	if (isnull(@Chu_Hang_ID, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập chủ hàng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Import_Excel_Template_Config with (nolock) where Chu_Hang_ID = @Chu_Hang_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Chủ hàng này đã khai báo rồi.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Import_Excel_Template_Config
	(
		Auto_ID,
		Chu_Hang_ID,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Chu_Hang_ID,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_520_IETC_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_520_IETC_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Import_Excel_Template_Config with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_520_IETC_sp_sel_List]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_520_IETC_sp_sel_List]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Chu_Hang_ID, Ma_Chu_Hang, Ten_Chu_Hang, Ten_Viet_Tat
	FROM 
		view_Sys_Import_Excel_Template_Config with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_520_IETC_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_520_IETC_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Chu_Hang_ID, Ma_Chu_Hang, Ten_Chu_Hang, Ten_Viet_Tat
	FROM 
		view_Sys_Import_Excel_Template_Config with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_520_IETC_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_520_IETC_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Chu_Hang_ID, Ma_Chu_Hang, Ten_Chu_Hang, Ten_Viet_Tat
	FROM 
		view_Sys_Import_Excel_Template_Config with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_520_IETC_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_520_IETC_sp_upd_Update]
	@Auto_ID bigint,
	@Chu_Hang_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	if (isnull(@Chu_Hang_ID, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập chủ hàng.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Import_Excel_Template_Config with (nolock) 
										where Chu_Hang_ID = @Chu_Hang_ID and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Chủ hàng này đã khai báo rồi.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Import_Excel_Template_Config SET
		Chu_Hang_ID = @Chu_Hang_ID,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_521_L_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_521_L_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Language SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_521_L_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_521_L_sp_ins_Insert]
	@Field_Name nvarchar(200),
	@Lang_1 nvarchar(200),
	@Lang_2 nvarchar(200),
	@Lang_3 nvarchar(200),
	@Lang_4 nvarchar(200),
	@Lang_5 nvarchar(200),
	@Type_ID int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Lang_1 = LTRIM(RTRIM(@Lang_1))
	set @Lang_2 = LTRIM(RTRIM(@Lang_2))
	set @Lang_3 = LTRIM(RTRIM(@Lang_3))
	set @Lang_4 = LTRIM(RTRIM(@Lang_4))
	set @Lang_5 = LTRIM(RTRIM(@Lang_5))

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Language with (nolock) where Field_Name = @Field_Name)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Language
	(
		Auto_ID,
		Field_Name,
		Lang_1,
		Lang_2,
		Lang_3,
		Lang_4,
		Lang_5,
		Type_ID,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Field_Name,
		@Lang_1,
		@Lang_2,
		@Lang_3,
		@Lang_4,
		@Lang_5,
		@Type_ID,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_521_L_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_521_L_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Language with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_521_L_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_521_L_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Field_Name, Lang_1, Lang_2, Lang_3, Lang_4, Lang_5, Type_ID
	FROM 
		view_Sys_Language with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_521_L_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_521_L_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Field_Name, Lang_1, Lang_2, Lang_3, Lang_4, Lang_5, Type_ID , Last_Updated
	FROM 
		view_Sys_Language with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_521_L_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_521_L_sp_upd_Update]
	@Auto_ID bigint,
	@Field_Name nvarchar(200),
	@Lang_1 nvarchar(200),
	@Lang_2 nvarchar(200),
	@Lang_3 nvarchar(200),
	@Lang_4 nvarchar(200),
	@Lang_5 nvarchar(200),
	@Type_ID int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Lang_1 = LTRIM(RTRIM(@Lang_1))
	set @Lang_2 = LTRIM(RTRIM(@Lang_2))
	set @Lang_3 = LTRIM(RTRIM(@Lang_3))
	set @Lang_4 = LTRIM(RTRIM(@Lang_4))
	set @Lang_5 = LTRIM(RTRIM(@Lang_5))

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Language with (nolock) where Field_Name = @Field_Name and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Language SET
		Field_Name = @Field_Name,
		Lang_1 = @Lang_1,
		Lang_2 = @Lang_2,
		Lang_3 = @Lang_3,
		Lang_4 = @Lang_4,
		Lang_5 = @Lang_5,
		Type_ID = @Type_ID,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_522_MC_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_522_MC_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Mau_Column SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_522_MC_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_522_MC_sp_ins_Insert]
	@Field_Name nvarchar(50),
	@Ma_So_Mau nvarchar(50),
	@Ghi_Chu nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Ma_So_Mau = LTRIM(RTRIM(@Ma_So_Mau))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_Mau_Column with (nolock) where Field_Name = @Field_Name)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Mau_Column
	(
		Auto_ID,
		Field_Name,
		Ma_So_Mau,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Field_Name,
		@Ma_So_Mau,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_522_MC_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_522_MC_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Mau_Column with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_522_MC_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_522_MC_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Field_Name, Ma_So_Mau, Ghi_Chu
	FROM 
		view_Sys_Mau_Column with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_522_MC_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_522_MC_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Field_Name, Ma_So_Mau, Last_Updated
	FROM 
		view_Sys_Mau_Column with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_522_MC_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_522_MC_sp_upd_Update]
	@Auto_ID bigint,
	@Field_Name nvarchar(50),
	@Ma_So_Mau nvarchar(50),
	@Ghi_Chu nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Field_Name = LTRIM(RTRIM(@Field_Name))
	set @Ma_So_Mau = LTRIM(RTRIM(@Ma_So_Mau))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Field_Name, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Field name.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_Mau_Column with (nolock) where Field_Name = @Field_Name and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Field name đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Mau_Column SET
		Field_Name = @Field_Name,
		Ma_So_Mau = @Ma_So_Mau,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_523_NP_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_523_NP_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Nhom_PDA SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_523_NP_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_523_NP_sp_ins_Insert]
	@Ten_Nhom_PDA nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Nhom_PDA = LTRIM(RTRIM(@Ten_Nhom_PDA))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ten_Nhom_PDA, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên nhóm PDA.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Nhom_PDA with (nolock) where Ten_Nhom_PDA = @Ten_Nhom_PDA)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Tên nhóm PDA đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Nhom_PDA
	(
		Auto_ID,
		Ten_Nhom_PDA,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ten_Nhom_PDA,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_523_NP_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_523_NP_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Nhom_PDA with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_523_NP_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_523_NP_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ten_Nhom_PDA, Ghi_Chu
	FROM 
		view_Sys_Nhom_PDA with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_523_NP_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_523_NP_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ten_Nhom_PDA, Ghi_Chu, Last_Updated
	FROM 
		view_Sys_Nhom_PDA with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_523_NP_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_523_NP_sp_upd_Update]
	@Auto_ID bigint,
	@Ten_Nhom_PDA nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Nhom_PDA = LTRIM(RTRIM(@Ten_Nhom_PDA))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ten_Nhom_PDA, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên nhóm PDA.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Nhom_PDA with (nolock) where Ten_Nhom_PDA = @Ten_Nhom_PDA and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Tên nhóm PDA đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Nhom_PDA SET
		Ten_Nhom_PDA = @Ten_Nhom_PDA,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_524_NPU_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_524_NPU_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Nhom_PDA_User SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_524_NPU_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_524_NPU_sp_ins_Insert]
	@Nhom_PDA_ID bigint,
	@Ma_Dang_Nhap nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))

	if (isnull(@Ma_Dang_Nhap, '') = '')
	begin
		RAISERROR(N'Vui lòng chọn User.', 11, 1)
		return
	end

	--declare @Key nvarchar(200) = @Nhom_PDA_ID + '|' + @Ma_Dang_Nhap

	declare @Check_ID_1 int = (select top 1 Auto_ID from view_Sys_Nhom_PDA_User with (nolock)
									where Ma_Dang_Nhap = @Ma_Dang_Nhap and Nhom_PDA_ID = @Nhom_PDA_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã đăng nhập đã tồn tại trong nhóm PDA.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Nhom_PDA_User
	(
		Auto_ID,
		Nhom_PDA_ID,
		Ma_Dang_Nhap,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Nhom_PDA_ID,
		@Ma_Dang_Nhap,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_524_NPU_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_524_NPU_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Nhom_PDA_User with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_524_NPU_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_524_NPU_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Nhom_PDA_ID, Ma_Dang_Nhap
	FROM 
		view_Sys_Nhom_PDA_User with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_524_NPU_sp_sel_List_By_Ma_Dang_Nhap]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_524_NPU_sp_sel_List_By_Ma_Dang_Nhap]
	@Ma_Dang_Nhap nvarchar(100)
	with recompile
AS
BEGIN
	SELECT Auto_ID, Nhom_PDA_ID, Ma_Dang_Nhap, Ten_Nhom_PDA 
	FROM 
		view_Sys_Nhom_PDA_User with (nolock)
	Where
		Ma_Dang_Nhap = @Ma_Dang_Nhap
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_524_NPU_sp_sel_List_By_Nhom_PDA_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_524_NPU_sp_sel_List_By_Nhom_PDA_ID]
	@Nhom_PDA_ID bigInt
	with recompile
AS
BEGIN
	SELECT Auto_ID, Nhom_PDA_ID, Ma_Dang_Nhap, Ho_Ten
	FROM 
		view_Sys_Nhom_PDA_User with (nolock)
	WHERE 
		Nhom_PDA_ID = @Nhom_PDA_ID
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_524_NPU_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_524_NPU_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Nhom_PDA_ID, Ma_Dang_Nhap, Ten_Nhom_PDA, Last_Updated
	FROM 
		view_Sys_Nhom_PDA_User with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_524_NPU_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_524_NPU_sp_upd_Update]
	@Auto_ID bigint,
	@Nhom_PDA_ID bigint,
	@Ma_Dang_Nhap nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))

	if (isnull(@Ma_Dang_Nhap, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã đăng nhập.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Nhom_PDA_User with (nolock) where Ma_Dang_Nhap = @Ma_Dang_Nhap and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã đăng nhập đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Nhom_PDA_User SET
		Nhom_PDA_ID = @Nhom_PDA_ID,
		Ma_Dang_Nhap = @Ma_Dang_Nhap,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_525_NTV_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_525_NTV_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Nhom_Thanh_Vien SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_525_NTV_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_525_NTV_sp_ins_Insert]
	@Ten_Nhom_Thanh_Vien nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Nhom_Thanh_Vien = LTRIM(RTRIM(@Ten_Nhom_Thanh_Vien))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ten_Nhom_Thanh_Vien, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên nhóm thành viên.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Nhom_Thanh_Vien with (nolock) where Ten_Nhom_Thanh_Vien = @Ten_Nhom_Thanh_Vien)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Tên nhóm thành viên đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Nhom_Thanh_Vien
	(
		Auto_ID,
		Ten_Nhom_Thanh_Vien,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ten_Nhom_Thanh_Vien,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_525_NTV_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_525_NTV_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Nhom_Thanh_Vien with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_525_NTV_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_525_NTV_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ten_Nhom_Thanh_Vien, Ghi_Chu
	FROM 
		view_Sys_Nhom_Thanh_Vien with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_525_NTV_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_525_NTV_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ten_Nhom_Thanh_Vien, Last_Updated
	FROM 
		view_Sys_Nhom_Thanh_Vien with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_525_NTV_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_525_NTV_sp_upd_Update]
	@Auto_ID bigint,
	@Ten_Nhom_Thanh_Vien nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ten_Nhom_Thanh_Vien = LTRIM(RTRIM(@Ten_Nhom_Thanh_Vien))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ten_Nhom_Thanh_Vien, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Tên nhóm thành viên.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Nhom_Thanh_Vien with (nolock) where Ten_Nhom_Thanh_Vien = @Ten_Nhom_Thanh_Vien and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Tên nhóm thành viên đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Nhom_Thanh_Vien SET
		Ten_Nhom_Thanh_Vien = @Ten_Nhom_Thanh_Vien,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_526_NTVU_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_526_NTVU_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Nhom_Thanh_Vien_User SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_526_NTVU_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_526_NTVU_sp_ins_Insert]
	@Nhom_Thanh_Vien_ID bigint,
	@Ma_Dang_Nhap nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))

	if (isnull(@Ma_Dang_Nhap, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã đăng nhập.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Nhom_Thanh_Vien_User with (nolock) where Ma_Dang_Nhap = @Ma_Dang_Nhap and Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã đăng nhập đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_Thanh_Vien with (nolock) where Ma_Dang_Nhap = @Ma_Dang_Nhap)
	if(isnull(@Check_ID_2, 0) = 0)
	begin
		RAISERROR(N'Mã đăng nhập không tồn tại trong danh sách thành viên.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Nhom_Thanh_Vien_User
	(
		Auto_ID,
		Nhom_Thanh_Vien_ID,
		Ma_Dang_Nhap,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Nhom_Thanh_Vien_ID,
		@Ma_Dang_Nhap,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	exec FTotal_sp_upd_Thanh_Vien @Ma_Dang_Nhap

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_526_NTVU_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_526_NTVU_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Nhom_Thanh_Vien_User with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_526_NTVU_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_526_NTVU_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Nhom_Thanh_Vien_ID, Ma_Dang_Nhap
	FROM 
		view_Sys_Nhom_Thanh_Vien_User with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_526_NTVU_sp_sel_List_By_Nhom_TV_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_526_NTVU_sp_sel_List_By_Nhom_TV_ID]
	@Nhom_Thanh_Vien_ID int
	with recompile
AS
BEGIN
	SELECT Auto_ID, Nhom_Thanh_Vien_ID, Ma_Dang_Nhap, Ho_Ten
	FROM 
		view_Sys_Nhom_Thanh_Vien_User with (nolock) 
	WHERE 
		Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_526_NTVU_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_526_NTVU_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Nhom_Thanh_Vien_ID, Ma_Dang_Nhap, Last_Updated
	FROM 
		view_Sys_Nhom_Thanh_Vien_User with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_526_NTVU_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_526_NTVU_sp_upd_Update]
	@Auto_ID bigint,
	@Nhom_Thanh_Vien_ID bigint,
	@Ma_Dang_Nhap nvarchar(50),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))

	if (isnull(@Ma_Dang_Nhap, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã đăng nhập.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Nhom_Thanh_Vien_User with (nolock) where Ma_Dang_Nhap = @Ma_Dang_Nhap and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã đăng nhập đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Nhom_Thanh_Vien_User SET
		Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID,
		Ma_Dang_Nhap = @Ma_Dang_Nhap,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_527_PQCN_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_527_PQCN_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Phan_Quyen_Chuc_Nang SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_527_PQCN_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_527_PQCN_sp_ins_Insert]
	@Nhom_Thanh_Vien_ID bigint,
	@Chuc_Nang_ID bigint,
	@Is_Have_View_Permission bit,
	@Is_Have_Add_Permission bit,
	@Is_Have_Edit_Permission bit,
	@Is_Have_Delete_Permission bit,
	@Is_Have_Export_Permission bit,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Phan_Quyen_Chuc_Nang
	(
		Auto_ID,
		Nhom_Thanh_Vien_ID,
		Chuc_Nang_ID,
		Is_Have_View_Permission,
		Is_Have_Add_Permission,
		Is_Have_Edit_Permission,
		Is_Have_Delete_Permission,
		Is_Have_Export_Permission,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Nhom_Thanh_Vien_ID,
		@Chuc_Nang_ID,
		@Is_Have_View_Permission,
		@Is_Have_Add_Permission,
		@Is_Have_Edit_Permission,
		@Is_Have_Delete_Permission,
		@Is_Have_Export_Permission,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_527_PQCN_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_527_PQCN_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Phan_Quyen_Chuc_Nang with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_527_PQCN_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_527_PQCN_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Nhom_Thanh_Vien_ID, Chuc_Nang_ID, Is_Have_View_Permission, Is_Have_Add_Permission, Is_Have_Edit_Permission, Is_Have_Delete_Permission, Is_Have_Export_Permission
	FROM 
		view_Sys_Phan_Quyen_Chuc_Nang with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_527_PQCN_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_527_PQCN_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Chuc_Nang_ID, Nhom_Thanh_Vien_ID, Is_Have_Add_Permission, Is_Have_Delete_Permission, Is_Have_Edit_Permission, 
		Is_Have_View_Permission, Is_Have_Export_Permission, Last_Updated
	FROM 
		view_Sys_Phan_Quyen_Chuc_Nang with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_527_PQCN_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_527_PQCN_sp_upd_Update]
	@Auto_ID bigint,
	@Nhom_Thanh_Vien_ID bigint,
	@Chuc_Nang_ID bigint,
	@Is_Have_View_Permission bit,
	@Is_Have_Add_Permission bit,
	@Is_Have_Edit_Permission bit,
	@Is_Have_Delete_Permission bit,
	@Is_Have_Export_Permission bit,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Phan_Quyen_Chuc_Nang SET
		Nhom_Thanh_Vien_ID = @Nhom_Thanh_Vien_ID,
		Chuc_Nang_ID = @Chuc_Nang_ID,
		Is_Have_View_Permission = @Is_Have_View_Permission,
		Is_Have_Add_Permission = @Is_Have_Add_Permission,
		Is_Have_Edit_Permission = @Is_Have_Edit_Permission,
		Is_Have_Delete_Permission = @Is_Have_Delete_Permission,
		Is_Have_Export_Permission = @Is_Have_Export_Permission,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_528_RTC_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_528_RTC_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Report_Template_Config SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_528_RTC_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_528_RTC_sp_ins_Insert]
	@Chu_Hang_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn chủ hàng.', 11, 1)
		return
	end 

	declare @CheckID int
	set @CheckID =(select Auto_ID from view_Sys_Report_Template_Config 
								where Chu_Hang_ID = @Chu_Hang_ID)

	if (isnull(@CheckID, 0) <> 0)
	begin
		RAISERROR(N'Chủ hàng này đã định nghĩa rồi.', 11, 1)
		return
	end 

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Report_Template_Config
	(
		Auto_ID,
		Chu_Hang_ID,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Chu_Hang_ID,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_528_RTC_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_528_RTC_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Report_Template_Config with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_528_RTC_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_528_RTC_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Chu_Hang_ID, Ma_Chu_Hang, Ten_Chu_Hang, Ten_Viet_Tat
	FROM 
		view_Sys_Report_Template_Config with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_528_RTC_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_528_RTC_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Chu_Hang_ID, Ma_Chu_Hang, Ten_Chu_Hang, Ten_Viet_Tat
	FROM 
		view_Sys_Report_Template_Config with (nolock) 
	ORDER BY Auto_ID DESC
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_528_RTC_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_528_RTC_sp_upd_Update]
	@Auto_ID bigint,
	@Chu_Hang_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn chủ hàng.', 11, 1)
		return
	end 

	declare @CheckID int
	set @CheckID =(select Auto_ID from view_Sys_Report_Template_Config 
								where Chu_Hang_ID = @Chu_Hang_ID and Auto_ID <> @Auto_ID)

	if (isnull(@CheckID, 0) <> 0)
	begin
		RAISERROR(N'Chủ hàng này đã định nghĩa rồi.', 11, 1)
		return
	end 

	UPDATE tbl_Sys_Report_Template_Config SET
		Chu_Hang_ID = @Chu_Hang_ID,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_529_SN_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_529_SN_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_STT_Next SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_529_SN_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_529_SN_sp_ins_Insert]
	@Chu_Hang_ID bigint,
	@Quy_Tac_Phieu nvarchar(50),
	@Type_ID int,
	@Digits int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Quy_Tac_Phieu = LTRIM(RTRIM(@Quy_Tac_Phieu))

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn chủ hàng.', 11, 1)
		return
	end

	if (isnull(@Quy_Tac_Phieu, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập quy tắc.', 11, 1)
		return
	end

	declare @Check_ID_1 int = (select top 1 Auto_ID from view_Sys_STT_Next with (nolock)
									where 
										Chu_Hang_ID = @Chu_Hang_ID 
										and Type_ID = @Type_ID
										and Quy_Tac_Phieu = @Quy_Tac_Phieu)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Quy tắc này đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_STT_Next
	(
		Auto_ID,
		Chu_Hang_ID,
		Quy_Tac_Phieu,
		Type_ID,
		Digits,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Chu_Hang_ID,
		@Quy_Tac_Phieu,
		@Type_ID,
		@Digits,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_529_SN_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_529_SN_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_STT_Next with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_529_SN_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_529_SN_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Chu_Hang_ID, Quy_Tac_Phieu, Type_ID, Digits, Ma_Chu_Hang,
		Ten_Chu_Hang
	FROM 
		view_Sys_STT_Next with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_529_SN_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_529_SN_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Chu_Hang_ID, Quy_Tac_Phieu, Type_ID, Digits, Ma_Chu_Hang, Ten_Chu_Hang
	FROM 
		view_Sys_STT_Next with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_529_SN_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_529_SN_sp_upd_Update]
	@Auto_ID bigint,
	@Chu_Hang_ID bigint,
	@Quy_Tac_Phieu nvarchar(50),
	@Type_ID int,
	@Digits int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Quy_Tac_Phieu = LTRIM(RTRIM(@Quy_Tac_Phieu))

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn chủ hàng.', 11, 1)
		return
	end

	if (isnull(@Quy_Tac_Phieu, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập quy tắc.', 11, 1)
		return
	end

	declare @Check_ID_1 int = (select top 1 Auto_ID from view_Sys_STT_Next with (nolock)
									where 
										Chu_Hang_ID = @Chu_Hang_ID 
										and Type_ID = @Type_ID
										and Quy_Tac_Phieu = @Quy_Tac_Phieu
										and Auto_ID != @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Quy tắc này đã tồn tại.', 11, 1)
		return
	end


	UPDATE tbl_Sys_STT_Next SET
		Chu_Hang_ID = @Chu_Hang_ID,
		Quy_Tac_Phieu = @Quy_Tac_Phieu,
		Type_ID = @Type_ID,
		Digits = @Digits,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_530_SND_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_530_SND_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_STT_Next_Detail SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_530_SND_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_530_SND_sp_ins_Insert]
	@STT_ID bigint,
	@Ngay_Giao_Dich datetime,
	@STT_Current int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ngay_Giao_Dich = dbo.fnConvert_Ngay_To_NULL(@Ngay_Giao_Dich)
	set @Ngay_Giao_Dich = dbo.fnConvert_To_Dau_Ngay(@Ngay_Giao_Dich)

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_STT_Next_Detail
	(
		Auto_ID,
		STT_ID,
		Ngay_Giao_Dich,
		STT_Current,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@STT_ID,
		@Ngay_Giao_Dich,
		@STT_Current,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_530_SND_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_530_SND_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_STT_Next_Detail with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_530_SND_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_530_SND_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, STT_ID, Ngay_Giao_Dich, STT_Current
	FROM 
		view_Sys_STT_Next_Detail with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_530_SND_sp_sel_List_By_STT_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_530_SND_sp_sel_List_By_STT_ID]
	@STT_ID bigint
	with recompile
AS
BEGIN
	SELECT * FROM view_Sys_STT_Next_Detail with (nolock)
	Where
		STT_ID = @STT_ID
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_530_SND_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_530_SND_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, STT_ID, Ngay_Giao_Dich, STT_Current, Type_ID, Quy_Tac_Phieu,
		Chu_Hang_ID, Ma_Chu_Hang
	FROM 
		view_Sys_STT_Next_Detail with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_530_SND_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_530_SND_sp_upd_Update]
	@Auto_ID bigint,
	@STT_ID bigint,
	@Ngay_Giao_Dich datetime,
	@STT_Current int,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ngay_Giao_Dich = dbo.fnConvert_Ngay_To_NULL(@Ngay_Giao_Dich)
	set @Ngay_Giao_Dich = dbo.fnConvert_To_Dau_Ngay(@Ngay_Giao_Dich)

	UPDATE tbl_Sys_STT_Next_Detail SET
		STT_ID = @STT_ID,
		Ngay_Giao_Dich = @Ngay_Giao_Dich,
		STT_Current = @STT_Current,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_531_TV_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_531_TV_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Thanh_Vien SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_531_TV_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_531_TV_sp_ins_Insert]
	@Ma_Dang_Nhap nvarchar(50),
	@Mat_Khau nvarchar(50),
	@Ho_Ten nvarchar(100),
	@Email nvarchar(250),
	@Dien_Thoai nvarchar(200),
	@Trang_Thai_ID int,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))
	set @Ho_Ten = LTRIM(RTRIM(@Ho_Ten))
	set @Email = LTRIM(RTRIM(@Email))
	set @Dien_Thoai = LTRIM(RTRIM(@Dien_Thoai))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_Dang_Nhap, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã đăng nhập.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Thanh_Vien with (nolock) where Ma_Dang_Nhap = @Ma_Dang_Nhap)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã đăng nhập đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Thanh_Vien
	(
		Auto_ID,
		Ma_Dang_Nhap,
		Mat_Khau,
		Ho_Ten,
		Email,
		Dien_Thoai,
		Trang_Thai_ID,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Dang_Nhap,
		@Mat_Khau,
		@Ho_Ten,
		@Email,
		@Dien_Thoai,
		@Trang_Thai_ID,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_531_TV_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_531_TV_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Thanh_Vien with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_531_TV_sp_sel_Get_By_Ma_Dang_Nhap]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_531_TV_sp_sel_Get_By_Ma_Dang_Nhap]
	@Ma_Dang_Nhap nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Thanh_Vien
	WHERE
		Ma_Dang_Nhap = @Ma_Dang_Nhap
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_531_TV_sp_sel_List]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_531_TV_sp_sel_List]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_Dang_Nhap, Mat_Khau, Ho_Ten, Email, Dien_Thoai, Hinh_Dai_Dien_URL, Trang_Thai_ID, Ten_Nhom_Thanh_Vien_Text, Ghi_Chu
	FROM 
		view_Sys_Thanh_Vien with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_531_TV_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_531_TV_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Dang_Nhap, Mat_Khau, Ho_Ten, Email, Dien_Thoai, Hinh_Dai_Dien_URL, Trang_Thai_ID, Ten_Nhom_Thanh_Vien_Text, Ghi_Chu
	FROM 
		view_Sys_Thanh_Vien with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_531_TV_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_531_TV_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Ma_Dang_Nhap, Ho_Ten, Ten_Nhom_Thanh_Vien_Text, Email, Dien_Thoai, Hinh_Dai_Dien_URL, Trang_Thai_ID,
		Created, Mat_Khau, Last_Updated
	FROM 
		view_Sys_Thanh_Vien with (nolock)
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_531_TV_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_531_TV_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_Dang_Nhap nvarchar(50),
	@Mat_Khau nvarchar(50),
	@Ho_Ten nvarchar(100),
	@Email nvarchar(250),
	@Dien_Thoai nvarchar(200),
	@Trang_Thai_ID int,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))
	set @Ho_Ten = LTRIM(RTRIM(@Ho_Ten))
	set @Email = LTRIM(RTRIM(@Email))
	set @Dien_Thoai = LTRIM(RTRIM(@Dien_Thoai))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_Dang_Nhap, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập Mã đăng nhập.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Thanh_Vien with (nolock) where Ma_Dang_Nhap = @Ma_Dang_Nhap and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã đăng nhập đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Thanh_Vien SET
		Ma_Dang_Nhap = @Ma_Dang_Nhap,
		Mat_Khau = @Mat_Khau,
		Ho_Ten = @Ho_Ten,
		Email = @Email,
		Dien_Thoai = @Dien_Thoai,
		Trang_Thai_ID = @Trang_Thai_ID,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_532_T_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_532_T_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Token SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_532_T_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_532_T_sp_ins_Insert]
	@Token_ID nvarchar(50),
	@Ma_Dang_Nhap nvarchar(50),
	@Token_Expired datetime,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Token_ID = LTRIM(RTRIM(@Token_ID))
	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Token
	(
		Auto_ID,
		Token_ID,
		Ma_Dang_Nhap,
		Token_Expired,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Token_ID,
		@Ma_Dang_Nhap,
		@Token_Expired,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_532_T_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_532_T_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Token with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_532_T_sp_sel_Get_By_Ma_Dang_Nhap]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_532_T_sp_sel_Get_By_Ma_Dang_Nhap]
	@Ma_Dang_Nhap nvarchar(200)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT top 1 * FROM view_Sys_Token
	WHERE
		Ma_Dang_Nhap = @Ma_Dang_Nhap
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_532_T_sp_sel_Get_By_Token_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_532_T_sp_sel_Get_By_Token_ID]
	@Token_ID nvarchar(200)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	---- Check xem kho đang active ở token có quyền không (trường hợp tắt phân quyền)
	--declare @Kho_ID int 
	--declare @Ma_Dang_Nhap nvarchar(200)
	--declare @Ten_Kho nvarchar(200)

	--select @Kho_ID = Kho_ID, @Ma_Dang_Nhap = Ma_Dang_Nhap, @Ten_Kho = Ten_Kho from view_Sys_Token where Token = @Token
	--if (isnull(@Kho_ID, 0) <> 0)
	--begin
	--	set @Kho_ID = (select top 1 Kho_ID from view_DM_Kho_User where Kho_ID = @Kho_ID and Ma_Dang_Nhap = @Ma_Dang_Nhap)
	--	if (isnull(@Kho_ID, 0) = 0)
	--		set @Ten_Kho = null
	--end

	---- Trong trường hợp kho null thì lấy kho đầu tiên làm mặc định (để không ảnh hưởng đến các apps cũ)
	--if (isnull(@Kho_ID, 0) = 0)
	--begin
	--	select top 1 @Kho_ID = Kho_ID, @Ten_Kho = Ten_Kho from view_DM_Kho_User where Ma_Dang_Nhap = @Ma_Dang_Nhap
	--end

	--SELECT top 1 A.Auto_ID, A.Token, A.Ma_Dang_Nhap, A.deleted, A.Created, A.Created_By, A.Last_Updated, A.Last_Updated_By, 
	--	A.Ho_Ten, @Kho_ID as Kho_ID, @Ten_Kho as Ten_Kho,
	--	(select top 1 Chu_Hang_ID from view_DM_Chu_Hang_User where Ma_Dang_Nhap = A.Ma_Dang_Nhap) as Chu_Hang_ID
	--FROM view_Sys_Token A
	--WHERE
	--	A.Token = @Token

	SELECT top 1 * FROM view_Sys_Token
	WHERE
		Token_ID = @Token_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_532_T_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_532_T_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Token_ID, Ma_Dang_Nhap, Token_Expired
	FROM 
		view_Sys_Token with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_532_T_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_532_T_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN
	SELECT Auto_ID, Token_ID, Ma_Dang_Nhap, Token_Expired, Last_Updated
	FROM
		view_Sys_Token
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_532_T_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_532_T_sp_upd_Update]
	@Auto_ID bigint,
	@Token_ID nvarchar(50),
	@Ma_Dang_Nhap nvarchar(50),
	@Token_Expired datetime,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Token_ID = LTRIM(RTRIM(@Token_ID))
	set @Ma_Dang_Nhap = LTRIM(RTRIM(@Ma_Dang_Nhap))

	UPDATE tbl_Sys_Token SET
		Token_ID = @Token_ID,
		Ma_Dang_Nhap = @Ma_Dang_Nhap,
		Token_Expired = @Token_Expired,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_533_W_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_533_W_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Webhook SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_533_W_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_533_W_sp_ins_Insert]
	@Ma_Webhook nvarchar(50),
	@Ten_Webhook nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Webhook = LTRIM(RTRIM(@Ma_Webhook))
	set @Ten_Webhook = LTRIM(RTRIM(@Ten_Webhook))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_Webhook, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập mã Webhook.', 11, 1)
		return
	end

	if (isnull(@Ten_Webhook, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập tên Webhook.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Webhook with (nolock) where Ma_Webhook = @Ma_Webhook)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã Webhook đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_Webhook with (nolock) where Ten_Webhook = @Ten_Webhook)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên Webhook đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Webhook
	(
		Auto_ID,
		Ma_Webhook,
		Ten_Webhook,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Ma_Webhook,
		@Ten_Webhook,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_533_W_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_533_W_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Webhook with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_533_W_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_533_W_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Ma_Webhook, Ten_Webhook, Ghi_Chu
	FROM 
		view_Sys_Webhook with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_533_W_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_533_W_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Ma_Webhook, Ten_Webhook, Last_Updated
	FROM 
		view_Sys_Webhook with (nolock) 
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_533_W_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_533_W_sp_upd_Update]
	@Auto_ID bigint,
	@Ma_Webhook nvarchar(50),
	@Ten_Webhook nvarchar(200),
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ma_Webhook = LTRIM(RTRIM(@Ma_Webhook))
	set @Ten_Webhook = LTRIM(RTRIM(@Ten_Webhook))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Ma_Webhook, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập mã Webhook.', 11, 1)
		return
	end

	if (isnull(@Ten_Webhook, '') = '')
	begin
		RAISERROR(N'Vui lòng nhập tên Webhook.', 11, 1)
		return
	end

	declare @Check_ID_1 bigint = (select top 1 Auto_ID from view_Sys_Webhook with (nolock) where Ma_Webhook = @Ma_Webhook and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Mã Webhook đã tồn tại.', 11, 1)
		return
	end

	declare @Check_ID_2 bigint = (select top 1 Auto_ID from view_Sys_Webhook with (nolock) where Ten_Webhook = @Ten_Webhook and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_2, 0) > 0)
	begin
		RAISERROR(N'Tên Webhook đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Webhook SET
		Ma_Webhook = @Ma_Webhook,
		Ten_Webhook = @Ten_Webhook,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_534_WCH_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_534_WCH_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_Sys_Webhook_Chu_Hang SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_534_WCH_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_534_WCH_sp_ins_Insert]
	@Chu_Hang_ID bigint,
	@Webhook_ID bigint,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn chủ hàng.', 11, 1)
		return
	end

	if (isnull(@Webhook_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn Webhook.', 11, 1)
		return
	end

	declare @Check_ID_1 int = (select top 1 Auto_ID from view_Sys_Webhook_Chu_Hang with (nolock)
									where Webhook_ID = @Webhook_ID and Chu_Hang_ID = @Chu_Hang_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Webhook khai báo cho chủ hàng đã tồn tại.', 11, 1)
		return
	end

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_Sys_Webhook_Chu_Hang
	(
		Auto_ID,
		Chu_Hang_ID,
		Webhook_ID,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Chu_Hang_ID,
		@Webhook_ID,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_534_WCH_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_534_WCH_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_Sys_Webhook_Chu_Hang with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_534_WCH_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[FQ_534_WCH_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Chu_Hang_ID, Webhook_ID, Ghi_Chu,
		Ma_Chu_Hang, Ten_Chu_Hang, Ten_Viet_Tat, Ma_Webhook, Ten_Webhook
	FROM 
		view_Sys_Webhook_Chu_Hang with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_534_WCH_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_534_WCH_sp_upd_Update]
	@Auto_ID bigint,
	@Chu_Hang_ID bigint,
	@Webhook_ID bigint,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	if (isnull(@Chu_Hang_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn chủ hàng.', 11, 1)
		return
	end

	if (isnull(@Webhook_ID, 0) = 0)
	begin
		RAISERROR(N'Vui lòng chọn Webhook.', 11, 1)
		return
	end

	declare @Check_ID_1 int = (select top 1 Auto_ID from view_Sys_Webhook_Chu_Hang with (nolock)
									where Webhook_ID = @Webhook_ID and Chu_Hang_ID = @Chu_Hang_ID and Auto_ID <> @Auto_ID)
	if(isnull(@Check_ID_1, 0) > 0)
	begin
		RAISERROR(N'Webhook khai báo cho chủ hàng đã tồn tại.', 11, 1)
		return
	end

	UPDATE tbl_Sys_Webhook_Chu_Hang SET
		Chu_Hang_ID = @Chu_Hang_ID,
		Webhook_ID = @Webhook_ID,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_718_NK_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_718_NK_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_XNK_Nhap_Kho SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_718_NK_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_718_NK_sp_ins_Insert]
	@So_Phieu_Nhap_Kho nvarchar(50),
	@Kho_ID bigint,
	@NCC_ID bigint,
	@Ngay_Nhap_Kho datetime,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @So_Phieu_Nhap_Kho = LTRIM(RTRIM(@So_Phieu_Nhap_Kho))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	set @Ngay_Nhap_Kho = dbo.fnConvert_Ngay_To_NULL(@Ngay_Nhap_Kho)
	set @Ngay_Nhap_Kho = dbo.fnConvert_To_Dau_Ngay(@Ngay_Nhap_Kho)

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_XNK_Nhap_Kho
	(
		Auto_ID,
		So_Phieu_Nhap_Kho,
		Kho_ID,
		NCC_ID,
		Ngay_Nhap_Kho,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@So_Phieu_Nhap_Kho,
		@Kho_ID,
		@NCC_ID,
		@Ngay_Nhap_Kho,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_718_NK_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_718_NK_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
--exec [dbo].[FQ_718_NK_sp_sel_Get_By_ID] 13911058
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_XNK_Nhap_Kho with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END

GO
/****** Object:  StoredProcedure [dbo].[FQ_718_NK_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_718_NK_sp_sel_List_By_Created]
	--@Kho_ID bigint,
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, So_Phieu_Nhap_Kho, Kho_ID, NCC_ID, Ngay_Nhap_Kho, Ghi_Chu
	FROM 
		view_XNK_Nhap_Kho with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
		--and Kho_ID = @Kho_ID
	ORDER BY Auto_ID DESC
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_718_NK_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_718_NK_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT  Auto_ID, So_Phieu_Nhap_Kho, Kho_ID, NCC_ID, Ngay_Nhap_Kho, Ghi_Chu
	FROM 
		view_XNK_Nhap_Kho with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_718_NK_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_718_NK_sp_upd_Update]
	@Auto_ID bigint,
	@So_Phieu_Nhap_Kho nvarchar(50),
	@Kho_ID bigint,
	@NCC_ID bigint,
	@Ngay_Nhap_Kho datetime,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @So_Phieu_Nhap_Kho = LTRIM(RTRIM(@So_Phieu_Nhap_Kho))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	set @Ngay_Nhap_Kho = dbo.fnConvert_Ngay_To_NULL(@Ngay_Nhap_Kho)
	set @Ngay_Nhap_Kho = dbo.fnConvert_To_Dau_Ngay(@Ngay_Nhap_Kho)

	UPDATE tbl_XNK_Nhap_Kho SET
		So_Phieu_Nhap_Kho = @So_Phieu_Nhap_Kho,
		Kho_ID = @Kho_ID,
		NCC_ID = @NCC_ID,
		Ngay_Nhap_Kho = @Ngay_Nhap_Kho,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_719_NKRD_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_719_NKRD_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_XNK_Nhap_Kho_Raw_Data SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_719_NKRD_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_719_NKRD_sp_ins_Insert]
	@Nhap_Kho_ID bigint,
	@San_Pham_ID bigint,
	@SL_Nhap bigint,
	@Don_Gia_Nhap bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_XNK_Nhap_Kho_Raw_Data
	(
		Auto_ID,
		Nhap_Kho_ID,
		San_Pham_ID,
		SL_Nhap,
		Don_Gia_Nhap,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Nhap_Kho_ID,
		@San_Pham_ID,
		@SL_Nhap,
		@Don_Gia_Nhap,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_719_NKRD_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_719_NKRD_sp_sel_Get_By_ID]
	@Nhap_Kho_ID bigint
	with recompile
AS
-- exec [dbo].[FQ_719_NKRD_sp_sel_Get_By_ID] 13911058
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_XNK_Nhap_Kho_Raw_Data with (nolock)
	WHERE
		Nhap_Kho_ID = @Nhap_Kho_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_719_NKRD_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_719_NKRD_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Nhap_Kho_ID, San_Pham_ID, SL_Nhap, Don_Gia_Nhap
	FROM 
		view_XNK_Nhap_Kho_Raw_Data with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_719_NKRD_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_719_NKRD_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Nhap_Kho_ID, San_Pham_ID, SL_Nhap, Don_Gia_Nhap
	FROM 
		view_XNK_Nhap_Kho_Raw_Data with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_719_NKRD_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_719_NKRD_sp_upd_Update]
	@Auto_ID bigint,
	@Nhap_Kho_ID bigint,
	@San_Pham_ID bigint,
	@SL_Nhap bigint,
	@Don_Gia_Nhap bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_XNK_Nhap_Kho_Raw_Data SET
		Nhap_Kho_ID = @Nhap_Kho_ID,
		San_Pham_ID = @San_Pham_ID,
		SL_Nhap = @SL_Nhap,
		Don_Gia_Nhap = @Don_Gia_Nhap,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_728_XK_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_728_XK_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_XNK_Xuat_Kho SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_728_XK_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_728_XK_sp_ins_Insert]
	@So_Phieu_Xuat_Kho nvarchar(50),
	@Kho_ID bigint,
	@Ngay_Xuat_Kho datetime,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @So_Phieu_Xuat_Kho = LTRIM(RTRIM(@So_Phieu_Xuat_Kho))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	set @Ngay_Xuat_Kho = dbo.fnConvert_Ngay_To_NULL(@Ngay_Xuat_Kho)
	set @Ngay_Xuat_Kho = dbo.fnConvert_To_Dau_Ngay(@Ngay_Xuat_Kho)

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_XNK_Xuat_Kho
	(
		Auto_ID,
		So_Phieu_Xuat_Kho,
		Kho_ID,
		Ngay_Xuat_Kho,
		Ghi_Chu,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@So_Phieu_Xuat_Kho,
		@Kho_ID,
		@Ngay_Xuat_Kho,
		@Ghi_Chu,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_728_XK_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_728_XK_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_XNK_Xuat_Kho with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_728_XK_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_728_XK_sp_sel_List_By_Created]
	--@Kho_ID bigint,
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, So_Phieu_Xuat_Kho, Kho_ID, Ngay_Xuat_Kho, Ghi_Chu
	FROM 
		view_XNK_Xuat_Kho with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
		--and Kho_ID = @Kho_ID
	ORDER BY Auto_ID DESC
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_728_XK_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_728_XK_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, So_Phieu_Xuat_Kho, Kho_ID, Ngay_Xuat_Kho, Ghi_Chu
	FROM 
		view_XNK_Xuat_Kho with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_728_XK_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_728_XK_sp_upd_Update]
	@Auto_ID bigint,
	@So_Phieu_Xuat_Kho nvarchar(50),
	@Kho_ID bigint,
	@Ngay_Xuat_Kho datetime,
	@Ghi_Chu nvarchar(200),
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	set @So_Phieu_Xuat_Kho = LTRIM(RTRIM(@So_Phieu_Xuat_Kho))
	set @Ghi_Chu = LTRIM(RTRIM(@Ghi_Chu))

	set @Ngay_Xuat_Kho = dbo.fnConvert_Ngay_To_NULL(@Ngay_Xuat_Kho)
	set @Ngay_Xuat_Kho = dbo.fnConvert_To_Dau_Ngay(@Ngay_Xuat_Kho)

	UPDATE tbl_XNK_Xuat_Kho SET
		So_Phieu_Xuat_Kho = @So_Phieu_Xuat_Kho,
		Kho_ID = @Kho_ID,
		Ngay_Xuat_Kho = @Ngay_Xuat_Kho,
		Ghi_Chu = @Ghi_Chu,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_734_XKRD_sp_del_Delete_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_734_XKRD_sp_del_Delete_By_ID]
	@Auto_ID bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_XNK_Xuat_Kho_Raw_Data SET
		deleted = 1,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_734_XKRD_sp_ins_Insert]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_734_XKRD_sp_ins_Insert]
	@Xuat_Kho_ID bigint,
	@San_Pham_ID bigint,
	@SL_Xuat bigint,
	@Don_Gia_Xuat bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	declare @Auto_ID bigint
	set @Auto_ID = (next value for dbo.Seq_ID)

	INSERT INTO tbl_XNK_Xuat_Kho_Raw_Data
	(
		Auto_ID,
		Xuat_Kho_ID,
		San_Pham_ID,
		SL_Xuat,
		Don_Gia_Xuat,
		deleted,
		Created,
		Created_By,
		Created_By_Function,
		Last_Updated,
		Last_Updated_By,
		Last_Updated_By_Function
	)
	VALUES
	(
		@Auto_ID,
		@Xuat_Kho_ID,
		@San_Pham_ID,
		@SL_Xuat,
		@Don_Gia_Xuat,
		0,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function,
		getdate(),
		@Last_Updated_By,
		@Last_Updated_By_Function
	)

	SELECT @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_734_XKRD_sp_sel_Get_By_ID]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_734_XKRD_sp_sel_Get_By_ID]
	@Auto_ID bigint
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	SELECT * FROM view_XNK_Xuat_Kho_Raw_Data with (nolock)
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_734_XKRD_sp_sel_List_By_Created]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_734_XKRD_sp_sel_List_By_Created]
	@Date_From datetime,
	@Date_To datetime
	with recompile
AS
BEGIN
	set @Date_From = dbo.fnConvert_To_Dau_Ngay(@Date_From)
	set @Date_To = dbo.fnConvert_To_Cuoi_Ngay(@Date_To)

	SELECT Auto_ID, Xuat_Kho_ID, San_Pham_ID, SL_Xuat, Don_Gia_Xuat
	FROM 
		view_XNK_Xuat_Kho_Raw_Data with (nolock) 
	WHERE 
		Created between @Date_From and @Date_To
	ORDER BY Auto_ID DESC
END


GO
/****** Object:  StoredProcedure [dbo].[FQ_734_XKRD_sp_sel_List_For_Cache]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_734_XKRD_sp_sel_List_For_Cache]
	with recompile
AS
BEGIN

	SELECT Auto_ID, Xuat_Kho_ID, San_Pham_ID, SL_Xuat, Don_Gia_Xuat
	FROM 
		view_XNK_Xuat_Kho_Raw_Data with (nolock) 
END
GO
/****** Object:  StoredProcedure [dbo].[FQ_734_XKRD_sp_upd_Update]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[FQ_734_XKRD_sp_upd_Update]
	@Auto_ID bigint,
	@Xuat_Kho_ID bigint,
	@San_Pham_ID bigint,
	@SL_Xuat bigint,
	@Don_Gia_Xuat bigint,
	@Last_Updated_By nvarchar(50),
	@Last_Updated_By_Function nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_XNK_Xuat_Kho_Raw_Data SET
		Xuat_Kho_ID = @Xuat_Kho_ID,
		San_Pham_ID = @San_Pham_ID,
		SL_Xuat = @SL_Xuat,
		Don_Gia_Xuat = @Don_Gia_Xuat,
		Last_Updated = getdate(),
		Last_Updated_By = @Last_Updated_By,
		Last_Updated_By_Function = @Last_Updated_By_Function
	WHERE
		Auto_ID = @Auto_ID
END


GO
/****** Object:  StoredProcedure [dbo].[FTotal_sp_upd_Thanh_Vien]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FTotal_sp_upd_Thanh_Vien]
	@Ma_Dang_Nhap nvarchar(50)
	with recompile
AS
BEGIN
	SET NOCOUNT ON;

	declare @Ten_Nhom_Thanh_Vien_Text nvarchar(400) = dbo.fnList_Nhom_Thanh_Vien_By_Ma_Dang_Nhap(@Ma_Dang_Nhap)

	update tbl_Sys_Thanh_Vien set
		Ten_Nhom_Thanh_Vien_Text = @Ten_Nhom_Thanh_Vien_Text
	where
		Ma_Dang_Nhap = @Ma_Dang_Nhap
END
GO
/****** Object:  StoredProcedure [dbo].[FUtil_sp_del_Delete_All_Data]    Script Date: 19/06/2025 14:38:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[FUtil_sp_del_Delete_All_Data]
	with recompile
AS
BEGIN
	SET NOCOUNT ON;
	declare @Table_Name nvarchar(200)
	declare @Sql nvarchar(2000)

	declare Table_Cursor CURSOR FOR
    SELECT Table_Name
    FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'
 
    OPEN Table_Cursor
    FETCH NEXT FROM Table_Cursor
    INTO @Table_Name
 
    WHILE @@FETCH_STATUS = 0
    BEGIN
		declare @Is_Truncate int = 0

		if (@Table_Name = N'tbl_Sys_Nhom_Thanh_Vien_User' or @Table_Name = N'tbl_Sys_Thanh_Vien')
		begin
			set @Sql = N'delete ' + @Table_Name + ' where Ma_Dang_Nhap <> ''admin'''
			exec sp_executesql @Sql

			set @Is_Truncate = 1
		end

		if (@Table_Name = N'tbl_Sys_Nhom_Thanh_Vien' or @Table_Name = N'tbl_Sys_Phan_Quyen_Chuc_Nang' 
			or @Table_Name = N'tbl_Sys_Chuc_Nang'
			or @Table_Name = N'tbl_Sys_Column_Width' or @Table_Name = N'tbl_Sys_Drill_Down'
			or @Table_Name = N'tbl_Sys_Hien_An_Column' or @Table_Name = N'tbl_Sys_Language'
			or @Table_Name = N'tbl_Sys_Mau_Column' or @Table_Name = N'tbl_Sys_API_Source' 
			or @Table_Name = N'tbl_Sys_API_Source_Function' or @Table_Name = N'tbl_Sys_Webhook' 
			or @Table_Name = N'tbl_Sys_Help_Guide')
		begin
			set @Is_Truncate = 1
		end

        if (isnull(@Is_Truncate, 0) = 0)
        BEGIN
			set @Sql = N'truncate table ' + @Table_Name
			exec sp_executesql @Sql
        END
 
        FETCH NEXT FROM Table_Cursor
		INTO @Table_Name
    END
    CLOSE Table_Cursor
    DEALLOCATE Table_Cursor
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 170
               Right = 248
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Log_Nhat_Ky_Truy_Cap_Chuc_Nang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Log_Nhat_Ky_Truy_Cap_Chuc_Nang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 297
               Right = 258
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Log_Record_Action_History'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Log_Record_Action_History'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 351
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_DM_Kho"
            Begin Extent = 
               Top = 394
               Left = 433
               Bottom = 591
               Right = 745
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_DM_Chu_Hang"
            Begin Extent = 
               Top = 91
               Left = 596
               Bottom = 288
               Right = 908
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Log_Report_File_Excel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Log_Report_File_Excel'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 275
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "D"
            Begin Extent = 
               Top = 279
               Left = 57
               Bottom = 476
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 276
               Left = 38
               Bottom = 406
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 408
               Left = 38
               Bottom = 538
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_API_Source_Chu_Hang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_API_Source_Chu_Hang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 210
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_Sys_API_Source_Function"
            Begin Extent = 
               Top = 62
               Left = 496
               Bottom = 192
               Right = 726
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_API_Source_Chu_Hang_Function'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_API_Source_Chu_Hang_Function'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 295
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Auto_Thread'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Auto_Thread'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_DM_Chu_Hang"
            Begin Extent = 
               Top = 49
               Left = 454
               Bottom = 232
               Right = 684
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Cau_Hinh_Component_App'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Cau_Hinh_Component_App'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 306
               Right = 317
            End
            DisplayFlags = 280
            TopColumn = 10
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Chuc_Nang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Chuc_Nang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 245
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_Sys_Nhom_PDA"
            Begin Extent = 
               Top = 69
               Left = 397
               Bottom = 285
               Right = 627
            End
            DisplayFlags = 280
            TopColumn = 1
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Chuc_Nang_App'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Chuc_Nang_App'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 6
               Left = 306
               Bottom = 136
               Right = 536
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 6
               Left = 574
               Bottom = 136
               Right = 804
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Daily_Schedule_Job'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Daily_Schedule_Job'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 405
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Grid_Field'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Grid_Field'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 387
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "view_Sys_Grid_Field"
            Begin Extent = 
               Top = 48
               Left = 620
               Bottom = 370
               Right = 932
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Grid_UI_Global'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Grid_UI_Global'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 282
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 105
               Left = 526
               Bottom = 302
               Right = 838
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Import_Excel_Template_Config'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Import_Excel_Template_Config'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 201
               Right = 317
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_Sys_Nhom_PDA"
            Begin Extent = 
               Top = 25
               Left = 387
               Bottom = 188
               Right = 656
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_Sys_Thanh_Vien"
            Begin Extent = 
               Top = 7
               Left = 710
               Bottom = 170
               Right = 991
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Nhom_PDA_User'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Nhom_PDA_User'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 301
               Right = 317
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 7
               Left = 365
               Bottom = 208
               Right = 646
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "C"
            Begin Extent = 
               Top = 7
               Left = 694
               Bottom = 170
               Right = 963
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1176
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1356
         SortOrder = 1416
         GroupBy = 1350
         Filter = 1356
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Nhom_Thanh_Vien_User'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Nhom_Thanh_Vien_User'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 7
               Left = 48
               Bottom = 306
               Right = 320
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Phan_Quyen_Chuc_Nang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Phan_Quyen_Chuc_Nang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 314
            End
            DisplayFlags = 280
            TopColumn = 28
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 140
               Left = 48
               Bottom = 303
               Right = 317
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Report_Template_Config'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Report_Template_Config'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 277
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_DM_Kho"
            Begin Extent = 
               Top = 284
               Left = 322
               Bottom = 414
               Right = 552
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_DM_Chu_Hang"
            Begin Extent = 
               Top = 61
               Left = 507
               Bottom = 243
               Right = 737
            End
            DisplayFlags = 280
            TopColumn = 2
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_STT_Next'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_STT_Next'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 9
               Left = 57
               Bottom = 206
               Right = 369
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "B"
            Begin Extent = 
               Top = 43
               Left = 845
               Bottom = 356
               Right = 1157
            End
            DisplayFlags = 280
            TopColumn = 9
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_STT_Next_Detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_STT_Next_Detail'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 275
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_Sys_Thanh_Vien"
            Begin Extent = 
               Top = 101
               Left = 463
               Bottom = 312
               Right = 703
            End
            DisplayFlags = 280
            TopColumn = 9
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Token'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Token'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "A"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 290
               Right = 268
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "view_Sys_Webhook"
            Begin Extent = 
               Top = 57
               Left = 432
               Bottom = 280
               Right = 662
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Webhook_Chu_Hang'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'view_Sys_Webhook_Chu_Hang'
GO
