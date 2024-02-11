import styled from 'styled-components'

const Row = styled.div<{
  align?: 'flex-start' | 'center' | 'flex-end'
  padding?: string
  border?: string
  borderRadius?: string
  gap?: string
}>`
  width: 100%;
  display: flex;
  align-items: ${({ align = 'center' }) => align};
  padding: ${({ padding = '0' }) => padding};
  border: ${({ border }) => border};
  border-radius: ${({ borderRadius }) => borderRadius};
  gap: ${({ gap }) => gap};
`

export const RowBetween = styled(Row)`
  justify-content: space-between;
`

export const RowCentered = styled(Row)`
  justify-content: center;
`

export const RowFlat = styled.div`
  display: flex;
  align-items: flex-end;
`

export const AutoRow = styled(Row)<{ gap?: string, justify?: string }>`
  flex-wrap: wrap;
  margin: ${({ gap }) => (gap ? `-${gap}` : '0')};
  justify-content: ${({ justify }) => justify};

  & > * {
    margin: ${({ gap }) => gap} !important;
  }
`

export const RowFixed = styled(Row)<{ gap?: string, justify?: string }>`
  width: fit-content;
  margin: ${({ gap }) => (gap ? `-${gap}` : '0')};
`

export default Row
