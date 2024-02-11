import { useAtom } from 'jotai'
import { atomWithStorage } from 'jotai/utils'

const transactionsAtom = atomWithStorage<string[]>('userTransactions', [])

export function useTransactionManager () {
  const [value, setValue] = useAtom(transactionsAtom)

  return {
    hashes: value,
    add: (hash: string) => { setValue((prev) => [...prev, hash]) }
  }
}
