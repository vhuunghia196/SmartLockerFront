import { getUserCookie } from 'utils/auth';
import { useRouter } from 'next/router';

export const withAuthRedirect = (WrappedComponent) => {
  return (props) => {
    const router = useRouter();
    const user = getUserCookie();

    // Nếu người dùng đã đăng nhập, điều hướng họ ra trang chính
    if (user) {
      router.push('/');
      return null;
    }

    // Nếu người dùng chưa đăng nhập, render component như bình thường
    return <WrappedComponent {...props} />;
  };
};