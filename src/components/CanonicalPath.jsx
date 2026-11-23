import { Navigate, useLocation } from 'react-router-dom';
import { canonicalizePathname } from '@/lib/routePaths';

export default function CanonicalPath({ children }) {
  const location = useLocation();
  const pathname = canonicalizePathname(location.pathname);
  if (pathname !== location.pathname) {
    return <Navigate replace to={{ pathname, search: location.search, hash: location.hash }} state={location.state} />;
  }
  return children;
}
