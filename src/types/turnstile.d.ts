interface Window {
  turnstile?: {
    render: (element: HTMLElement, options: Record<string, unknown>) => string;
    remove: (id: string) => void;
  };
}
