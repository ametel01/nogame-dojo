import { useContractRead } from '@starknet-react/core';
import erc721 from '../constants/erc721.json';
import { ERC721ADDRESS } from '../constants/addresses';
import { BlockTag } from 'starknet';

export function useTokenOf(address: string | undefined) {
  const { data, isLoading } = useContractRead({
    address: ERC721ADDRESS,
    abi: erc721.abi,
    functionName: 'token_of',
    args: [address!],
    watch: false,
    blockIdentifier: BlockTag.pending,
  });

  const planetId = data as unknown as number;

  return { planetId, isLoading };
}
