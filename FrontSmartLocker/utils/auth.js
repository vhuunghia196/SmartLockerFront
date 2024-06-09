import Cookies from 'js-cookie';

const USER_COOKIE_NAME = 'user';
const TOKEN_COOKIE_NAME = 'accessToken';

export const setUserCookie = (user, expirationDuration) => {
  const expirationDate = new Date(new Date().getTime() + expirationDuration);
  Cookies.set(USER_COOKIE_NAME, JSON.stringify(user), { expires: expirationDate });
};

export const getUserCookie = () => {
  const userCookie = Cookies.get(USER_COOKIE_NAME);
  return userCookie ? JSON.parse(userCookie) : null;
};

export const removeUserCookie = () => {
  Cookies.remove(USER_COOKIE_NAME);
};

export const setTokenCookie = (token, expirationDuration) => {
  const expirationDate = new Date(new Date().getTime() + expirationDuration);
  Cookies.set(TOKEN_COOKIE_NAME, token, { expires: expirationDate });
};

export const getTokenCookie = () => {
  return Cookies.get(TOKEN_COOKIE_NAME);
};

export const removeTokenCookie = () => {
  Cookies.remove(TOKEN_COOKIE_NAME);
};

export const clearAllAuthCookies = () => {
  removeUserCookie();
  removeTokenCookie();
};
export const setAllAuthCookies = (user, token , expirationDuration) => {
    setTokenCookie(token, expirationDuration);
    setUserCookie(user, expirationDuration)
  };
