import React from 'react';
import { Button } from '@/components/ui/button';
import { Leaf, RefreshCw } from 'lucide-react';

export default class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }

  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }

  componentDidCatch(error, errorInfo) {
    console.error('Unhandled application error:', error, errorInfo);
  }

  handleReload = () => {
    window.location.reload();
  };

  handleGoHome = () => {
    window.location.href = '/';
  };

  render() {
    if (this.state.hasError) {
      return (
        <div className="min-h-screen flex items-center justify-center bg-gray-50 p-4">
          <div className="max-w-md w-full bg-white rounded-xl shadow-lg border border-gray-100 p-6 text-center space-y-4">
            <div className="w-14 h-14 bg-green-100 text-green-700 rounded-full flex items-center justify-center mx-auto shadow-inner">
              <Leaf className="w-7 h-7" />
            </div>
            <h2 className="text-xl font-bold text-gray-900">Something went wrong</h2>
            <p className="text-sm text-gray-600 leading-relaxed">
              An unexpected error occurred while loading this page. You can try reloading or returning to the homepage.
            </p>
            <div className="flex flex-col sm:flex-row gap-2 justify-center pt-2">
              <Button
                variant="outline"
                onClick={this.handleGoHome}
                className="w-full sm:w-auto"
              >
                Go to Home
              </Button>
              <Button
                onClick={this.handleReload}
                className="w-full sm:w-auto bg-green-700 hover:bg-green-800 text-white flex items-center justify-center gap-2"
              >
                <RefreshCw className="w-4 h-4" />
                Reload Page
              </Button>
            </div>
          </div>
        </div>
      );
    }

    return this.props.children;
  }
}
