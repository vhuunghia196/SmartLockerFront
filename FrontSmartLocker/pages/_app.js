// import node module libraries
import Head from 'next/head';
import { useRouter } from 'next/router';
import { NextSeo } from 'next-seo';
import SSRProvider from 'react-bootstrap/SSRProvider';
import { Analytics } from '@vercel/analytics/react';
import { useEffect, useContext, createContext } from 'react';
// import theme style scss file
import 'styles/theme.scss';
// import default layouts
import DefaultDashboardLayout from 'layouts/DefaultDashboardLayout';
import { AuthProvider } from 'context/AuthContext';

import { getUserCookie } from 'utils/auth'
//css
import '../styles/theme/components/order-list.scss';
import '../styles/theme/components/LockerManagement.scss';
import '../styles/theme/components/user.scss';
import '../styles/theme/components/location.scss';
import '../styles/theme/components/RecordUsingLockerChart.module.scss';

function MyApp({ Component, pageProps }) {
  const router = useRouter();
  const pageURL = process.env.baseURL + router.pathname;
  const title = "Tủ khóa thông minh";
  const description = "Trang quản lý dành cho tủ khóa thông minh là một bộ công cụ hiện đại và tiện ích, giúp bạn quản lý dễ dàng các hoạt động và dữ liệu của tủ khóa. Với giao diện được thiết kế linh hoạt và chức năng đa dạng, trang admin này sẽ giúp bạn quản lý tủ khóa một cách hiệu quả và tiện lợi."
  const keywords = "web, app, Next JS, Smart Locker, Tủ khóa thông minh, Tủ khóa để đồ"
  // Identify the layout, which will be applied conditionally
  const Layout = Component.Layout || (router.pathname.includes('dashboard') ?
    (router.pathname.includes('instructor') || router.pathname.includes('student') ?
      DefaultDashboardLayout : DefaultDashboardLayout) : DefaultDashboardLayout);
  const user = getUserCookie();
  useEffect(() => {
    // Kiểm tra nếu user không tồn tại và không phải ở trang đăng nhập, thực hiện chuyển hướng đến trang đăng nhập
    if (!user) {
      if (router.pathname === '/authentication/sign-in' || router.pathname === '/')
        router.push('/authentication/sign-in');
    }
    // Kiểm tra nếu user đã đăng nhập và đang cố gắng truy cập trang đăng nhập, thì chuyển hướng họ đến trang chính
    if (user && (router.pathname === '/authentication/sign-in' || router.pathname === '/authentication/sign-up')) {
      router.push('/');
    }
  }, [user, router]);
  return (
    <AuthProvider>

      <SSRProvider>
        <Head>
          <meta name="viewport" content="width=device-width, initial-scale=1" />
          <meta name="keywords" content={keywords} />
          <link rel="shortcut icon" href="/favicon.ico" type="image/x-icon" />
        </Head>
        <NextSeo
          title={title}
          description={description}
          canonical={pageURL}
          openGraph={{
            url: pageURL,
            title: title,
            description: description,
            site_name: process.env.siteName
          }}
        />
        <Layout>
          <Component {...pageProps} />
          <Analytics />
        </Layout>
      </SSRProvider>
    </AuthProvider>
  )
}


export default MyApp
