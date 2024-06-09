// context/AuthContext.js

import { createContext, useContext, useState, useEffect } from 'react';
import { useRouter } from 'next/router';
const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isLoggedIn, setIsLoggedIn] = useState(false);
  const [user, setUser] = useState(null);
  const router = useRouter();

  // useEffect(() => {
  //   // Kiểm tra nếu user không tồn tại và không phải ở trang đăng nhập, thực hiện chuyển hướng đến trang đăng nhập
  //   if (!user) {
  //       if(router.pathname === '/authentication/sign-in')
  //           router.push('/authentication/sign-in');
  //       if(router.pathname === '/authentication/sign-up')
  //           router.push('/authentication/sign-up');     
  //       if(router.pathname === '/authentication/forget-password')
  //           router.push('/authentication/forget-password');     

  //   }
  //   // Kiểm tra nếu user đã đăng nhập và đang cố gắng truy cập trang đăng nhập, thì chuyển hướng họ đến trang chính
  //   if (user && (router.pathname === '/authentication/sign-in' || router.pathname === '/authentication/sign-up' || router.pathname === '/authentication/forget-password')) {
  //     router.push('/');
  //   }
  // }, [user, router]);

  const login = (userData) => {
    setIsLoggedIn(true);
    setUser(userData);
  };

  const logout = () => {
    setIsLoggedIn(false);
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ isLoggedIn, user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
