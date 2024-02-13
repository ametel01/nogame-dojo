import React, { createContext, useContext, useState, ReactNode } from 'react';

// Create a context
type DestinationContextType = {
  selectedDestination: number | null;
  handleDestinationClick: (destinationId: number) => void;
};

// Create a context with a default value
const DestinationContext = createContext<DestinationContextType>({
  selectedDestination: null,
  handleDestinationClick: () => {},
});

// Create a provider component
export const DestinationProvider = ({ children }: { children: ReactNode }) => {
  const [selectedDestination, setSelectedDestination] = useState<number | null>(
    null
  );

  const handleDestinationClick = (destinationId: number) => {
    setSelectedDestination(destinationId);
  };

  return (
    <DestinationContext.Provider
      value={{ selectedDestination, handleDestinationClick }}
    >
      {children}
    </DestinationContext.Provider>
  );
};

// Hook for easy access to the context
export const useDestination = () => useContext(DestinationContext);
