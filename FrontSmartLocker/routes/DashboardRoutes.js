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
	// {
	// 	id: uuid(),
	// 	title: 'Bảo mật',
	// 	icon: 'lock',
	// 	children: [
	// 		{ id: uuid(), link: '/authentication/forget-password', name: 'Forget Password'},
	// 		{ id: uuid(), link: '/authentication/sign-in', name: 'Đăng nhập'}	,
	// 		{ id: uuid(), link: '/authentication/sign-up', name: 'Đăng ký'}				
	// 	]
	// },
	// {
	// 	id: uuid(),
	// 	title: 'Bảo mật',
	// 	icon: 'lock',
	// 	children: [
	// 		{ id: uuid(), link: '/authentication/forget-password', name: 'Forget Password'}
	// 	]
		
	// },
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
			{ id: uuid(), link: '/components/ChartUsingLocker', name: 'Số lượng sử dụng tủ' },
		]
	},	
	{
		id: uuid(),
		title: 'Documentation',
		grouptitle: true
	},
	{
		id: uuid(),
		title: 'Docs',
		icon: 'clipboard',
		link: '/documentation'
	}

];

export default DashboardMenu;
