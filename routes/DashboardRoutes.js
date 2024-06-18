import { v4 as uuid } from 'uuid';
import { getUserCookie } from 'utils/auth';
export const DashboardMenu = [
	{
		id: uuid(),
		title: 'Trang chủ',
		icon: 'home',
		link: '/'
	},
	{
		id: uuid(),
		title: 'Cài đặt',
		icon: 'layers',
		children: [
			{ id: uuid(), link: '/pages/profile', name: 'Thông tin cá nhân' }
		]
	},	
	{
		id: uuid(),
		title: 'Danh sách bảng',
		grouptitle: true
	},	
	{
		id: uuid(),
		title: 'Bảng',
		icon: 'monitor',
		children: [
			{ id: uuid(), link: '/components/order-list', name: 'Đơn hàng' },
			{ id: uuid(), link: '/components/user-management', name: 'Người dùng' },
			{ id: uuid(), link: '/components/locker-management', name: 'Tủ' },
			{ id: uuid(), link: '/components/location-management', name: 'Địa điểm' },
		]
	},	
	{
		id: uuid(),
		title: 'Thống kê',
		icon: 'corner-left-down',
		children: [
			{ id: uuid(), link: '/components/ChartUsingLocker', name: 'Số lần sử dụng tủ' },
			{ id: uuid(), link: '/components/ChartLogin', name: 'Số lần đăng nhập' },
		]
	},	

];

export default DashboardMenu;
