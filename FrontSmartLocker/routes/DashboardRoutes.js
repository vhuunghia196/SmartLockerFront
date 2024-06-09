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
		title: 'Components',
		icon: 'monitor',
		children: [
			{ id: uuid(), link: '/components/accordions', name: 'Accordions' },
			{ id: uuid(), link: '/components/alerts', name: 'Alerts' },
			{ id: uuid(), link: '/components/badges', name: 'Badges' },
			{ id: uuid(), link: '/components/breadcrumbs', name: 'Breadcrumbs' },
			{ id: uuid(), link: '/components/buttons', name: 'Buttons' },
			{ id: uuid(), link: '/components/button-group', name: 'ButtonGroup' },
			{ id: uuid(), link: '/components/cards', name: 'Cards' },
			{ id: uuid(), link: '/components/carousels', name: 'Carousel' },
			{ id: uuid(), link: '/components/close-button', name: 'Close Button' },
			{ id: uuid(), link: '/components/collapse', name: 'Collapse' },
			{ id: uuid(), link: '/components/dropdowns', name: 'Dropdowns' },
			{ id: uuid(), link: '/components/list-group', name: 'Listgroup' },
			{ id: uuid(), link: '/components/modal', name: 'Modal' },
			{ id: uuid(), link: '/components/navs', name: 'Navs' },
			{ id: uuid(), link: '/components/navbar', name: 'Navbar' },
			{ id: uuid(), link: '/components/offcanvas', name: 'Offcanvas' },
			{ id: uuid(), link: '/components/overlays', name: 'Overlays' },
			{ id: uuid(), link: '/components/pagination', name: 'Pagination' },
			{ id: uuid(), link: '/components/popovers', name: 'Popovers' },
			{ id: uuid(), link: '/components/progress', name: 'Progress' },
			{ id: uuid(), link: '/components/spinners', name: 'Spinners' },
			{ id: uuid(), link: '/components/tables', name: 'Tables' },
			{ id: uuid(), link: '/components/toasts', name: 'Toasts' },
			{ id: uuid(), link: '/components/tooltips', name: 'Tooltips' }
		]
	},	
	{
		id: uuid(),
		title: 'Menu Level',
		icon: 'corner-left-down',
		children: [
			{ 
				id: uuid(), 
				link: '#', 
				title: 'Two Level',
				children: [
					{ id: uuid(), link: '#', name: 'NavItem 1'},
					{ id: uuid(), link: '#', name: 'NavItem 2' }
				]
			},
			{ 
				id: uuid(), 
				link: '#', 
				title: 'Three Level',
				children: [
					{ 
						id: uuid(), 
						link: '#', 
						title: 'NavItem 1',
						children: [
							{ id: uuid(), link: '#', name: 'NavChildItem 1'},
							{ id: uuid(), link: '#', name: 'NavChildItem 2'}
						]
					},
					{ id: uuid(), link: '#', name: 'NavItem 2' }
				]
			}
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
