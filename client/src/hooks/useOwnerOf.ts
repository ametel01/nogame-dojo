import { useContractRead } from '@starknet-react/core';
import erc721 from '../constants/erc721.json';
import { ERC721ADDRESS } from '../constants/addresses';
import { BlockTag } from 'starknet';

export function useOwnerOf(planetId: number) {
  const id = { low: Number(planetId), high: 0 };
  const { data, isLoading, error } = useContractRead({
    address: ERC721ADDRESS,
    abi: erc721.abi,
    functionName: 'owner_of',
    args: [id],
    watch: false,
    blockIdentifier: BlockTag.pending,
  });
  return { data, isLoading, error };
}
