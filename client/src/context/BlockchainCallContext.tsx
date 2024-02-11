import React, {
  createContext,
  useContext,
  useState,
  useCallback,
  PropsWithChildren,
} from 'react';
import { Call } from 'starknet';
import { SingleCall, CallType } from '../multicall/MultiCallTransaction';
import { getColonyUpgradeType, getUpgradeNameById } from '../shared/types';
import { useContract } from '@starknet-react/core';
import game from '../constants/nogame.json';
import { GAMEADDRESS } from '../constants/addresses';
import { getUpgradeType, getBuildType } from '../shared/types';
import { getColonyBuildType } from '../shared/types/index';

interface BlockchainCallContextProps {
  selectedCalls: Call[];
  singleCalls: SingleCall[];
  addCall: (
    callType: CallType,
    unitName: number,
    quantity: number,
    colonyId: number
  ) => void;
  removeCall: (index: number) => void;
  setSelectedCalls: (calls: Call[]) => void;
  setSingleCalls: (calls: SingleCall[]) => void;
  // ... other functions and states
}

const defaultContextValue: BlockchainCallContextProps = {
  selectedCalls: [],
  singleCalls: [],
  addCall: () => {},
  removeCall: () => {},
  setSelectedCalls: () => {},
  setSingleCalls: () => {},
};

const BlockchainCallContext =
  createContext<BlockchainCallContextProps>(defaultContextValue);

export const BlockchainCallProvider: React.FC<PropsWithChildren<object>> = ({
  children,
}) => {
  const [selectedCalls, setSelectedCalls] = useState<Call[]>([]);
  const [singleCalls, setSingleCalls] = useState<SingleCall[]>([]);

  const { contract } = useContract({
    abi: game.abi,
    address: GAMEADDRESS,
  });

  const createCall = (
    callType: CallType,
    unitName: number,
    quantity: number,
    colonyId: number
  ): Call => {
    switch (callType) {
      case 'compound':
        if (colonyId == 0) {
          return contract?.populateTransaction['process_compound_upgrade']!(
            getUpgradeType(unitName)!,
            quantity
          );
        }
        return contract?.populateTransaction[
          'process_colony_compound_upgrade'
        ]!(colonyId, getColonyUpgradeType(unitName)!, quantity);
      case 'tech':
        if (colonyId == 0) {
          return contract?.populateTransaction['process_tech_upgrade']!(
            getUpgradeType(unitName)!,
            quantity
          );
        }
        return contract?.populateTransaction['process_colony_tech_upgrade']!(
          colonyId,
          getColonyUpgradeType(unitName)!,
          quantity
        );
      case 'ship':
        if (colonyId == 0) {
          return contract?.populateTransaction['process_ship_build']!(
            getBuildType(unitName)!,
            quantity
          );
        }
        return contract?.populateTransaction['process_colony_unit_build']!(
          colonyId,
          getColonyBuildType(unitName)!,
          quantity
        );
      case 'defence':
        if (colonyId == 0) {
          return contract?.populateTransaction['process_defence_build']!(
            getBuildType(unitName)!,
            quantity
          );
        }
        return contract?.populateTransaction['process_colony_unit_build']!(
          colonyId,
          getColonyBuildType(unitName)!,
          quantity
        );
      default:
        throw new Error('Invalid call type');
    }
  };

  const addCall = (
    callType: CallType,
    unitName: number,
    quantity: number,
    colonyId: number
  ) => {
    const call = createCall(callType as CallType, unitName, quantity, colonyId);
    setSelectedCalls([...selectedCalls, call]);

    const singleCall: SingleCall = {
      type: callType,
      name:
        callType == 'compound' || callType == 'tech'
          ? getUpgradeNameById(unitName, false)
          : getUpgradeNameById(unitName, true),
      quantity: quantity,
      colonyId: colonyId,
    };
    setSingleCalls([...singleCalls, singleCall]);
  };

  const removeCall = useCallback((indexToRemove: number) => {
    setSingleCalls((currentCalls) =>
      currentCalls.filter((_, index) => index !== indexToRemove)
    );
    setSelectedCalls((currentCalls) =>
      currentCalls.filter((_, index) => index !== indexToRemove)
    );
  }, []);

  // ... other functions and states

  return (
    <BlockchainCallContext.Provider
      value={{
        selectedCalls,
        setSelectedCalls,
        singleCalls,
        setSingleCalls,
        addCall,
        removeCall,
      }}
    >
      {children}
    </BlockchainCallContext.Provider>
  );
};

export const useBlockchainCall = () => useContext(BlockchainCallContext);
