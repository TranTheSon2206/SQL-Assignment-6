use master
go
if EXISTS (select * from sys.databases where name='thuvien')
drop database thuvien
go
create database thuvien
go
use thuvien
create table ThongytinSach(
	Masach int identity primary key,
	tensach varchar(30) not null,
	tacgia varchar(20) not null,
	loaisach varchar(15),
	ndtt nvarchar(100) null
	);
create table Nxb(
	MaNxb int identity(110,1) primary key,
	tenNxb varchar(10) default 'KimDong',
	diachi varchar(20)
	);
create table SachXuatban(
	Masach int ,
	MaNxb int,
	NamXB date default '1999',
	lanXB int default '1',
	giaban money ,
	soluong int 
	constraint fk_masach foreign key (Masach) references ThongytinSach(Masach),
	constraint fk_MaNxb foreign key (MaNxb) references Nxb(MaNxb),
	constraint pk_saxb primary key (Masach,manxb)
	);

	insert into ThongytinSach values('Tri tue Do thai','Eran Katz','Khoahocxahoi','Bạn có muốn biết: Người Do Thái...');
	insert into ThongytinSach values('How to Code','Nguyen Tuan','LapTrinh','abcxyz');
	insert into ThongytinSach values('Cooking with Eva','Eva Kirk','Nau An','abcxyz');
	insert into ThongytinSach values('Ielts Speaking','Tran Son','Giao duc','abcxyz');
	insert into ThongytinSach values('Tu chu tai chinh','Khoa pug','Kinh te','abcxyz');
	insert into ThongytinSach values('haha','Eran Katz','Khoahocxahoi','aaa');

	insert into Nxb values('ThanhNien','Hanoi');
	insert into Nxb values('DaiNam','HoChiMinh');
	insert into Nxb values('TroiAu','DaNang');

	insert into SachXuatban values('1','110','2000','1','79000','100');
	insert into SachXuatban values('2','110','1998','2','89000','100');
	insert into SachXuatban values('3','111','2009','1','79000','200');
	insert into SachXuatban values('4','111','2003','1','9000','100');
	insert into SachXuatban values('5','112','2010','2','5000','500');
	insert into SachXuatban values('5','110','2000','3','3000','300');
	insert into SachXuatban values('4','110','2012','1','9000','100');

	--3. Liệt kê các cuốn sách có năm xuất bản từ 2008 đến nay
	select ThongytinSach.tensach,lanXB, SachXuatban.NamXB from ThongytinSach join SachXuatban on SachXuatban.Masach=ThongytinSach.Masach 
	where sachxuatban.namXB>'2008-01-01';

	--4. Liệt kê 10 cuốn sách có giá bán cao nhất
	select top 2 tensach, giaban from ThongytinSach join SachXuatban on ThongytinSach.Masach=SachXuatban.Masach
	order by giaban desc

	--5. Tìm những cuốn sách có tiêu đề chứa từ “tai chinh”
	select * from ThongytinSach where ThongytinSach.tensach like '%tai chinh%';

	--6. Liệt kê các cuốn sách có tên bắt đầu với chữ “T” theo thứ tự giá giảm dần
	select * from ThongytinSach where ThongytinSach.tensach like 't%' order by tensach desc;

	--7. Liệt kê các cuốn sách của nhà xuất bản thanhnien
	select Nxb.tenNxb, ThongytinSach.tensach from (Nxb  join SachXuatban on Nxb.MaNxb=SachXuatban.MaNxb) right join ThongytinSach
	on ThongytinSach.Masach=SachXuatban.Masach
	where tenNxb='thanhnien';

	--8. Lấy thông tin chi tiết về nhà xuất bản xuất bản cuốn sách “Trí tuệ Do Thái”
	select tennxb,diachi from (Nxb  join SachXuatban on Nxb.MaNxb=SachXuatban.MaNxb) right join ThongytinSach
	on ThongytinSach.Masach=SachXuatban.Masach
	where tensach='Tri tue Do thai'

	--9. Hiển thị các thông tin sau về các cuốn sách: Mã sách, Tên sách, Năm xuất bản, Nhà xuất bản, Loại sách
	select ThongytinSach.Masach, tensach, namXb, tennxb, loaisach from (Nxb  join SachXuatban on Nxb.MaNxb=SachXuatban.MaNxb) join ThongytinSach
	on ThongytinSach.Masach=SachXuatban.Masach 

	--10. Tìm cuốn sách có giá bán đắt nhất
	select ThongytinSach.tensach, SachXuatban.giaban,Nxb.tenNxb from (Nxb  join SachXuatban on Nxb.MaNxb=SachXuatban.MaNxb) join ThongytinSach
	on ThongytinSach.Masach=SachXuatban.Masach 
	where giaban=(select max(giaban) from SachXuatban)

	--11. Tìm cuốn sách có số lượng lớn nhất trong kho
	select ThongytinSach.tensach, SachXuatban.soluong,Nxb.tenNxb from (Nxb  join SachXuatban on Nxb.MaNxb=SachXuatban.MaNxb) join ThongytinSach
	on ThongytinSach.Masach=SachXuatban.Masach 
	where soluong=(select max(soluong) from SachXuatban)

	--12. Tìm các cuốn sách của tác giả “Eran Katz”
	select * from ThongytinSach 
	where ThongytinSach.tacgia='Eran Katz'

	--13. Giảm giá bán 10% các cuốn sách xuất bản từ năm 2008 trở về trước
	update SachXuatban set giaban = (giaban-giaban*0.1) where NamXB < '2008-01-01'

	--14. Thống kê số đầu sách của mỗi nhà xuất bản
	select nxb.tenNxb, sum(SachXuatban.soluong) as 'tong so dau sach' from Nxb join SachXuatban on Nxb.MaNxb = SachXuatban.MaNxb
	group by tenNxb

	--15. Thống kê số đầu sách của mỗi loại sách
	select ThongytinSach.loaisach, sum(sachxuatban.soluong) as 'tong so dau sach' from ThongytinSach join SachXuatban on SachXuatban.Masach=ThongytinSach.Masach
	group by loaisach

	--16. Đặt chỉ mục (Index) cho trường tên sách
	create index indx_tensach
	on thongytinsach (tensach)

	create view xemsach
	as
	select ThongytinSach.Masach,ThongytinSach.tensach,ThongytinSach.tacgia,Nxb.tenNxb,giaban from (Nxb  join SachXuatban on Nxb.MaNxb=SachXuatban.MaNxb) join ThongytinSach
	on ThongytinSach.Masach=SachXuatban.Masach
	
	select * from xemsach

	--18. Viết Store Procedure:
		--SP_Them_Sach: thêm mới một cuốn sách
		--SP_Tim_Sach: Tìm các cuốn sách theo từ khóa
		--SP_Sach_ChuyenMuc: Liệt kê các cuốn sách theo mã chuyên mục

	--19. Viết trigger không cho phép xóa các cuốn sách vẫn còn trong kho (số lượng > 0)

	--20. Viết trigger chỉ cho phép xóa một danh mục sách khi không còn cuốn sách nào thuộc chuyên mục này.