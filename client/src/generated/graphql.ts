import { GraphQLClient, RequestOptions } from 'graphql-request';
import { GraphQLError, print } from 'graphql';
import gql from 'graphql-tag';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = {
  [K in keyof T]: T[K];
};
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]?: Maybe<T[SubKey]>;
};
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & {
  [SubKey in K]: Maybe<T[SubKey]>;
};
export type MakeEmpty<
  T extends { [key: string]: unknown },
  K extends keyof T
> = { [_ in K]?: never };
export type Incremental<T> =
  | T
  | {
      [P in keyof T]?: P extends ' $fragmentName' | '__typename' ? T[P] : never;
    };
type GraphQLClientRequestHeaders = RequestOptions['requestHeaders'];
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: { input: string; output: string };
  String: { input: string; output: string };
  Boolean: { input: boolean; output: boolean };
  Int: { input: number; output: number };
  Float: { input: number; output: number };
  ContractAddress: { input: unknown; output: unknown };
  Cursor: { input: unknown; output: unknown };
  DateTime: { input: unknown; output: unknown };
  felt252: { input: unknown; output: unknown };
  u8: { input: unknown; output: unknown };
  u16: { input: unknown; output: unknown };
  u32: { input: unknown; output: unknown };
  u64: { input: unknown; output: unknown };
  u128: { input: unknown; output: unknown };
  usize: { input: unknown; output: unknown };
};

export type ActiveMission = {
  __typename?: 'ActiveMission';
  entity?: Maybe<World__Entity>;
  mission?: Maybe<ActiveMission_Mission>;
  mission_id?: Maybe<Scalars['usize']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type ActiveMissionConnection = {
  __typename?: 'ActiveMissionConnection';
  edges?: Maybe<Array<Maybe<ActiveMissionEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type ActiveMissionEdge = {
  __typename?: 'ActiveMissionEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<ActiveMission>;
};

export type ActiveMissionLen = {
  __typename?: 'ActiveMissionLen';
  entity?: Maybe<World__Entity>;
  lenght?: Maybe<Scalars['usize']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type ActiveMissionLenConnection = {
  __typename?: 'ActiveMissionLenConnection';
  edges?: Maybe<Array<Maybe<ActiveMissionLenEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type ActiveMissionLenEdge = {
  __typename?: 'ActiveMissionLenEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<ActiveMissionLen>;
};

export type ActiveMissionLenOrder = {
  direction: OrderDirection;
  field: ActiveMissionLenOrderField;
};

export enum ActiveMissionLenOrderField {
  Lenght = 'LENGHT',
  PlanetId = 'PLANET_ID',
}

export type ActiveMissionLenWhereInput = {
  lenght?: InputMaybe<Scalars['usize']['input']>;
  lenghtEQ?: InputMaybe<Scalars['usize']['input']>;
  lenghtGT?: InputMaybe<Scalars['usize']['input']>;
  lenghtGTE?: InputMaybe<Scalars['usize']['input']>;
  lenghtLT?: InputMaybe<Scalars['usize']['input']>;
  lenghtLTE?: InputMaybe<Scalars['usize']['input']>;
  lenghtNEQ?: InputMaybe<Scalars['usize']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type ActiveMissionOrder = {
  direction: OrderDirection;
  field: ActiveMissionOrderField;
};

export enum ActiveMissionOrderField {
  Mission = 'MISSION',
  MissionId = 'MISSION_ID',
  PlanetId = 'PLANET_ID',
}

export type ActiveMissionWhereInput = {
  mission_id?: InputMaybe<Scalars['usize']['input']>;
  mission_idEQ?: InputMaybe<Scalars['usize']['input']>;
  mission_idGT?: InputMaybe<Scalars['usize']['input']>;
  mission_idGTE?: InputMaybe<Scalars['usize']['input']>;
  mission_idLT?: InputMaybe<Scalars['usize']['input']>;
  mission_idLTE?: InputMaybe<Scalars['usize']['input']>;
  mission_idNEQ?: InputMaybe<Scalars['usize']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type ActiveMission_Fleet = {
  __typename?: 'ActiveMission_Fleet';
  armade?: Maybe<Scalars['u32']['output']>;
  carrier?: Maybe<Scalars['u32']['output']>;
  frigate?: Maybe<Scalars['u32']['output']>;
  scraper?: Maybe<Scalars['u32']['output']>;
  sparrow?: Maybe<Scalars['u32']['output']>;
};

export type ActiveMission_Mission = {
  __typename?: 'ActiveMission_Mission';
  category?: Maybe<Scalars['u8']['output']>;
  destination?: Maybe<Scalars['u32']['output']>;
  fleet?: Maybe<ActiveMission_Fleet>;
  id?: Maybe<Scalars['u32']['output']>;
  origin?: Maybe<Scalars['u32']['output']>;
  time_arrival?: Maybe<Scalars['u64']['output']>;
  time_start?: Maybe<Scalars['u64']['output']>;
};

export type ColonyCompounds = {
  __typename?: 'ColonyCompounds';
  colony_id?: Maybe<Scalars['u8']['output']>;
  entity?: Maybe<World__Entity>;
  level?: Maybe<Scalars['u8']['output']>;
  name?: Maybe<Scalars['u8']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type ColonyCompoundsConnection = {
  __typename?: 'ColonyCompoundsConnection';
  edges?: Maybe<Array<Maybe<ColonyCompoundsEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type ColonyCompoundsEdge = {
  __typename?: 'ColonyCompoundsEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<ColonyCompounds>;
};

export type ColonyCompoundsOrder = {
  direction: OrderDirection;
  field: ColonyCompoundsOrderField;
};

export enum ColonyCompoundsOrderField {
  ColonyId = 'COLONY_ID',
  Level = 'LEVEL',
  Name = 'NAME',
  PlanetId = 'PLANET_ID',
}

export type ColonyCompoundsWhereInput = {
  colony_id?: InputMaybe<Scalars['u8']['input']>;
  colony_idEQ?: InputMaybe<Scalars['u8']['input']>;
  colony_idGT?: InputMaybe<Scalars['u8']['input']>;
  colony_idGTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idLT?: InputMaybe<Scalars['u8']['input']>;
  colony_idLTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idNEQ?: InputMaybe<Scalars['u8']['input']>;
  level?: InputMaybe<Scalars['u8']['input']>;
  levelEQ?: InputMaybe<Scalars['u8']['input']>;
  levelGT?: InputMaybe<Scalars['u8']['input']>;
  levelGTE?: InputMaybe<Scalars['u8']['input']>;
  levelLT?: InputMaybe<Scalars['u8']['input']>;
  levelLTE?: InputMaybe<Scalars['u8']['input']>;
  levelNEQ?: InputMaybe<Scalars['u8']['input']>;
  name?: InputMaybe<Scalars['u8']['input']>;
  nameEQ?: InputMaybe<Scalars['u8']['input']>;
  nameGT?: InputMaybe<Scalars['u8']['input']>;
  nameGTE?: InputMaybe<Scalars['u8']['input']>;
  nameLT?: InputMaybe<Scalars['u8']['input']>;
  nameLTE?: InputMaybe<Scalars['u8']['input']>;
  nameNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type ColonyCount = {
  __typename?: 'ColonyCount';
  count?: Maybe<Scalars['u8']['output']>;
  entity?: Maybe<World__Entity>;
  game_id?: Maybe<Scalars['u8']['output']>;
};

export type ColonyCountConnection = {
  __typename?: 'ColonyCountConnection';
  edges?: Maybe<Array<Maybe<ColonyCountEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type ColonyCountEdge = {
  __typename?: 'ColonyCountEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<ColonyCount>;
};

export type ColonyCountOrder = {
  direction: OrderDirection;
  field: ColonyCountOrderField;
};

export enum ColonyCountOrderField {
  Count = 'COUNT',
  GameId = 'GAME_ID',
}

export type ColonyCountWhereInput = {
  count?: InputMaybe<Scalars['u8']['input']>;
  countEQ?: InputMaybe<Scalars['u8']['input']>;
  countGT?: InputMaybe<Scalars['u8']['input']>;
  countGTE?: InputMaybe<Scalars['u8']['input']>;
  countLT?: InputMaybe<Scalars['u8']['input']>;
  countLTE?: InputMaybe<Scalars['u8']['input']>;
  countNEQ?: InputMaybe<Scalars['u8']['input']>;
  game_id?: InputMaybe<Scalars['u8']['input']>;
  game_idEQ?: InputMaybe<Scalars['u8']['input']>;
  game_idGT?: InputMaybe<Scalars['u8']['input']>;
  game_idGTE?: InputMaybe<Scalars['u8']['input']>;
  game_idLT?: InputMaybe<Scalars['u8']['input']>;
  game_idLTE?: InputMaybe<Scalars['u8']['input']>;
  game_idNEQ?: InputMaybe<Scalars['u8']['input']>;
};

export type ColonyDefences = {
  __typename?: 'ColonyDefences';
  colony_id?: Maybe<Scalars['u8']['output']>;
  count?: Maybe<Scalars['u32']['output']>;
  entity?: Maybe<World__Entity>;
  name?: Maybe<Scalars['u8']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type ColonyDefencesConnection = {
  __typename?: 'ColonyDefencesConnection';
  edges?: Maybe<Array<Maybe<ColonyDefencesEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type ColonyDefencesEdge = {
  __typename?: 'ColonyDefencesEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<ColonyDefences>;
};

export type ColonyDefencesOrder = {
  direction: OrderDirection;
  field: ColonyDefencesOrderField;
};

export enum ColonyDefencesOrderField {
  ColonyId = 'COLONY_ID',
  Count = 'COUNT',
  Name = 'NAME',
  PlanetId = 'PLANET_ID',
}

export type ColonyDefencesWhereInput = {
  colony_id?: InputMaybe<Scalars['u8']['input']>;
  colony_idEQ?: InputMaybe<Scalars['u8']['input']>;
  colony_idGT?: InputMaybe<Scalars['u8']['input']>;
  colony_idGTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idLT?: InputMaybe<Scalars['u8']['input']>;
  colony_idLTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idNEQ?: InputMaybe<Scalars['u8']['input']>;
  count?: InputMaybe<Scalars['u32']['input']>;
  countEQ?: InputMaybe<Scalars['u32']['input']>;
  countGT?: InputMaybe<Scalars['u32']['input']>;
  countGTE?: InputMaybe<Scalars['u32']['input']>;
  countLT?: InputMaybe<Scalars['u32']['input']>;
  countLTE?: InputMaybe<Scalars['u32']['input']>;
  countNEQ?: InputMaybe<Scalars['u32']['input']>;
  name?: InputMaybe<Scalars['u8']['input']>;
  nameEQ?: InputMaybe<Scalars['u8']['input']>;
  nameGT?: InputMaybe<Scalars['u8']['input']>;
  nameGTE?: InputMaybe<Scalars['u8']['input']>;
  nameLT?: InputMaybe<Scalars['u8']['input']>;
  nameLTE?: InputMaybe<Scalars['u8']['input']>;
  nameNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type ColonyOwner = {
  __typename?: 'ColonyOwner';
  colony_planet_id?: Maybe<Scalars['u32']['output']>;
  entity?: Maybe<World__Entity>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type ColonyOwnerConnection = {
  __typename?: 'ColonyOwnerConnection';
  edges?: Maybe<Array<Maybe<ColonyOwnerEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type ColonyOwnerEdge = {
  __typename?: 'ColonyOwnerEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<ColonyOwner>;
};

export type ColonyOwnerOrder = {
  direction: OrderDirection;
  field: ColonyOwnerOrderField;
};

export enum ColonyOwnerOrderField {
  ColonyPlanetId = 'COLONY_PLANET_ID',
  PlanetId = 'PLANET_ID',
}

export type ColonyOwnerWhereInput = {
  colony_planet_id?: InputMaybe<Scalars['u32']['input']>;
  colony_planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  colony_planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  colony_planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  colony_planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  colony_planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  colony_planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type ColonyPosition = {
  __typename?: 'ColonyPosition';
  colony_id?: Maybe<Scalars['u8']['output']>;
  entity?: Maybe<World__Entity>;
  planet_id?: Maybe<Scalars['u32']['output']>;
  position?: Maybe<ColonyPosition_Position>;
};

export type ColonyPositionConnection = {
  __typename?: 'ColonyPositionConnection';
  edges?: Maybe<Array<Maybe<ColonyPositionEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type ColonyPositionEdge = {
  __typename?: 'ColonyPositionEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<ColonyPosition>;
};

export type ColonyPositionOrder = {
  direction: OrderDirection;
  field: ColonyPositionOrderField;
};

export enum ColonyPositionOrderField {
  ColonyId = 'COLONY_ID',
  PlanetId = 'PLANET_ID',
  Position = 'POSITION',
}

export type ColonyPositionWhereInput = {
  colony_id?: InputMaybe<Scalars['u8']['input']>;
  colony_idEQ?: InputMaybe<Scalars['u8']['input']>;
  colony_idGT?: InputMaybe<Scalars['u8']['input']>;
  colony_idGTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idLT?: InputMaybe<Scalars['u8']['input']>;
  colony_idLTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type ColonyPosition_Position = {
  __typename?: 'ColonyPosition_Position';
  orbit?: Maybe<Scalars['u8']['output']>;
  system?: Maybe<Scalars['u16']['output']>;
};

export type ColonyResource = {
  __typename?: 'ColonyResource';
  amount?: Maybe<Scalars['u128']['output']>;
  colony_id?: Maybe<Scalars['u8']['output']>;
  entity?: Maybe<World__Entity>;
  name?: Maybe<Scalars['u8']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type ColonyResourceConnection = {
  __typename?: 'ColonyResourceConnection';
  edges?: Maybe<Array<Maybe<ColonyResourceEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type ColonyResourceEdge = {
  __typename?: 'ColonyResourceEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<ColonyResource>;
};

export type ColonyResourceOrder = {
  direction: OrderDirection;
  field: ColonyResourceOrderField;
};

export enum ColonyResourceOrderField {
  Amount = 'AMOUNT',
  ColonyId = 'COLONY_ID',
  Name = 'NAME',
  PlanetId = 'PLANET_ID',
}

export type ColonyResourceTimer = {
  __typename?: 'ColonyResourceTimer';
  colony_id?: Maybe<Scalars['u8']['output']>;
  entity?: Maybe<World__Entity>;
  last_collection?: Maybe<Scalars['u64']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type ColonyResourceTimerConnection = {
  __typename?: 'ColonyResourceTimerConnection';
  edges?: Maybe<Array<Maybe<ColonyResourceTimerEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type ColonyResourceTimerEdge = {
  __typename?: 'ColonyResourceTimerEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<ColonyResourceTimer>;
};

export type ColonyResourceTimerOrder = {
  direction: OrderDirection;
  field: ColonyResourceTimerOrderField;
};

export enum ColonyResourceTimerOrderField {
  ColonyId = 'COLONY_ID',
  LastCollection = 'LAST_COLLECTION',
  PlanetId = 'PLANET_ID',
}

export type ColonyResourceTimerWhereInput = {
  colony_id?: InputMaybe<Scalars['u8']['input']>;
  colony_idEQ?: InputMaybe<Scalars['u8']['input']>;
  colony_idGT?: InputMaybe<Scalars['u8']['input']>;
  colony_idGTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idLT?: InputMaybe<Scalars['u8']['input']>;
  colony_idLTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idNEQ?: InputMaybe<Scalars['u8']['input']>;
  last_collection?: InputMaybe<Scalars['u64']['input']>;
  last_collectionEQ?: InputMaybe<Scalars['u64']['input']>;
  last_collectionGT?: InputMaybe<Scalars['u64']['input']>;
  last_collectionGTE?: InputMaybe<Scalars['u64']['input']>;
  last_collectionLT?: InputMaybe<Scalars['u64']['input']>;
  last_collectionLTE?: InputMaybe<Scalars['u64']['input']>;
  last_collectionNEQ?: InputMaybe<Scalars['u64']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type ColonyResourceWhereInput = {
  amount?: InputMaybe<Scalars['u128']['input']>;
  amountEQ?: InputMaybe<Scalars['u128']['input']>;
  amountGT?: InputMaybe<Scalars['u128']['input']>;
  amountGTE?: InputMaybe<Scalars['u128']['input']>;
  amountLT?: InputMaybe<Scalars['u128']['input']>;
  amountLTE?: InputMaybe<Scalars['u128']['input']>;
  amountNEQ?: InputMaybe<Scalars['u128']['input']>;
  colony_id?: InputMaybe<Scalars['u8']['input']>;
  colony_idEQ?: InputMaybe<Scalars['u8']['input']>;
  colony_idGT?: InputMaybe<Scalars['u8']['input']>;
  colony_idGTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idLT?: InputMaybe<Scalars['u8']['input']>;
  colony_idLTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idNEQ?: InputMaybe<Scalars['u8']['input']>;
  name?: InputMaybe<Scalars['u8']['input']>;
  nameEQ?: InputMaybe<Scalars['u8']['input']>;
  nameGT?: InputMaybe<Scalars['u8']['input']>;
  nameGTE?: InputMaybe<Scalars['u8']['input']>;
  nameLT?: InputMaybe<Scalars['u8']['input']>;
  nameLTE?: InputMaybe<Scalars['u8']['input']>;
  nameNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type ColonyShips = {
  __typename?: 'ColonyShips';
  colony_id?: Maybe<Scalars['u8']['output']>;
  count?: Maybe<Scalars['u32']['output']>;
  entity?: Maybe<World__Entity>;
  name?: Maybe<Scalars['u8']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type ColonyShipsConnection = {
  __typename?: 'ColonyShipsConnection';
  edges?: Maybe<Array<Maybe<ColonyShipsEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type ColonyShipsEdge = {
  __typename?: 'ColonyShipsEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<ColonyShips>;
};

export type ColonyShipsOrder = {
  direction: OrderDirection;
  field: ColonyShipsOrderField;
};

export enum ColonyShipsOrderField {
  ColonyId = 'COLONY_ID',
  Count = 'COUNT',
  Name = 'NAME',
  PlanetId = 'PLANET_ID',
}

export type ColonyShipsWhereInput = {
  colony_id?: InputMaybe<Scalars['u8']['input']>;
  colony_idEQ?: InputMaybe<Scalars['u8']['input']>;
  colony_idGT?: InputMaybe<Scalars['u8']['input']>;
  colony_idGTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idLT?: InputMaybe<Scalars['u8']['input']>;
  colony_idLTE?: InputMaybe<Scalars['u8']['input']>;
  colony_idNEQ?: InputMaybe<Scalars['u8']['input']>;
  count?: InputMaybe<Scalars['u32']['input']>;
  countEQ?: InputMaybe<Scalars['u32']['input']>;
  countGT?: InputMaybe<Scalars['u32']['input']>;
  countGTE?: InputMaybe<Scalars['u32']['input']>;
  countLT?: InputMaybe<Scalars['u32']['input']>;
  countLTE?: InputMaybe<Scalars['u32']['input']>;
  countNEQ?: InputMaybe<Scalars['u32']['input']>;
  name?: InputMaybe<Scalars['u8']['input']>;
  nameEQ?: InputMaybe<Scalars['u8']['input']>;
  nameGT?: InputMaybe<Scalars['u8']['input']>;
  nameGTE?: InputMaybe<Scalars['u8']['input']>;
  nameLT?: InputMaybe<Scalars['u8']['input']>;
  nameLTE?: InputMaybe<Scalars['u8']['input']>;
  nameNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type GameOwnerPlanet = {
  __typename?: 'GameOwnerPlanet';
  entity?: Maybe<World__Entity>;
  owner?: Maybe<Scalars['ContractAddress']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type GameOwnerPlanetConnection = {
  __typename?: 'GameOwnerPlanetConnection';
  edges?: Maybe<Array<Maybe<GameOwnerPlanetEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type GameOwnerPlanetEdge = {
  __typename?: 'GameOwnerPlanetEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<GameOwnerPlanet>;
};

export type GameOwnerPlanetOrder = {
  direction: OrderDirection;
  field: GameOwnerPlanetOrderField;
};

export enum GameOwnerPlanetOrderField {
  Owner = 'OWNER',
  PlanetId = 'PLANET_ID',
}

export type GameOwnerPlanetWhereInput = {
  owner?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type GamePlanet = {
  __typename?: 'GamePlanet';
  entity?: Maybe<World__Entity>;
  owner?: Maybe<Scalars['ContractAddress']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type GamePlanetConnection = {
  __typename?: 'GamePlanetConnection';
  edges?: Maybe<Array<Maybe<GamePlanetEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type GamePlanetCount = {
  __typename?: 'GamePlanetCount';
  count?: Maybe<Scalars['u32']['output']>;
  entity?: Maybe<World__Entity>;
  game_id?: Maybe<Scalars['u8']['output']>;
};

export type GamePlanetCountConnection = {
  __typename?: 'GamePlanetCountConnection';
  edges?: Maybe<Array<Maybe<GamePlanetCountEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type GamePlanetCountEdge = {
  __typename?: 'GamePlanetCountEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<GamePlanetCount>;
};

export type GamePlanetCountOrder = {
  direction: OrderDirection;
  field: GamePlanetCountOrderField;
};

export enum GamePlanetCountOrderField {
  Count = 'COUNT',
  GameId = 'GAME_ID',
}

export type GamePlanetCountWhereInput = {
  count?: InputMaybe<Scalars['u32']['input']>;
  countEQ?: InputMaybe<Scalars['u32']['input']>;
  countGT?: InputMaybe<Scalars['u32']['input']>;
  countGTE?: InputMaybe<Scalars['u32']['input']>;
  countLT?: InputMaybe<Scalars['u32']['input']>;
  countLTE?: InputMaybe<Scalars['u32']['input']>;
  countNEQ?: InputMaybe<Scalars['u32']['input']>;
  game_id?: InputMaybe<Scalars['u8']['input']>;
  game_idEQ?: InputMaybe<Scalars['u8']['input']>;
  game_idGT?: InputMaybe<Scalars['u8']['input']>;
  game_idGTE?: InputMaybe<Scalars['u8']['input']>;
  game_idLT?: InputMaybe<Scalars['u8']['input']>;
  game_idLTE?: InputMaybe<Scalars['u8']['input']>;
  game_idNEQ?: InputMaybe<Scalars['u8']['input']>;
};

export type GamePlanetEdge = {
  __typename?: 'GamePlanetEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<GamePlanet>;
};

export type GamePlanetOrder = {
  direction: OrderDirection;
  field: GamePlanetOrderField;
};

export enum GamePlanetOrderField {
  Owner = 'OWNER',
  PlanetId = 'PLANET_ID',
}

export type GamePlanetOwner = {
  __typename?: 'GamePlanetOwner';
  entity?: Maybe<World__Entity>;
  owner?: Maybe<Scalars['ContractAddress']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type GamePlanetOwnerConnection = {
  __typename?: 'GamePlanetOwnerConnection';
  edges?: Maybe<Array<Maybe<GamePlanetOwnerEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type GamePlanetOwnerEdge = {
  __typename?: 'GamePlanetOwnerEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<GamePlanetOwner>;
};

export type GamePlanetOwnerOrder = {
  direction: OrderDirection;
  field: GamePlanetOwnerOrderField;
};

export enum GamePlanetOwnerOrderField {
  Owner = 'OWNER',
  PlanetId = 'PLANET_ID',
}

export type GamePlanetOwnerWhereInput = {
  owner?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type GamePlanetWhereInput = {
  owner?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerGT?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerGTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerLT?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerLTE?: InputMaybe<Scalars['ContractAddress']['input']>;
  ownerNEQ?: InputMaybe<Scalars['ContractAddress']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type GameSetup = {
  __typename?: 'GameSetup';
  entity?: Maybe<World__Entity>;
  game_id?: Maybe<Scalars['u8']['output']>;
  speed?: Maybe<Scalars['usize']['output']>;
  start_time?: Maybe<Scalars['u64']['output']>;
};

export type GameSetupConnection = {
  __typename?: 'GameSetupConnection';
  edges?: Maybe<Array<Maybe<GameSetupEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type GameSetupEdge = {
  __typename?: 'GameSetupEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<GameSetup>;
};

export type GameSetupOrder = {
  direction: OrderDirection;
  field: GameSetupOrderField;
};

export enum GameSetupOrderField {
  GameId = 'GAME_ID',
  Speed = 'SPEED',
  StartTime = 'START_TIME',
}

export type GameSetupWhereInput = {
  game_id?: InputMaybe<Scalars['u8']['input']>;
  game_idEQ?: InputMaybe<Scalars['u8']['input']>;
  game_idGT?: InputMaybe<Scalars['u8']['input']>;
  game_idGTE?: InputMaybe<Scalars['u8']['input']>;
  game_idLT?: InputMaybe<Scalars['u8']['input']>;
  game_idLTE?: InputMaybe<Scalars['u8']['input']>;
  game_idNEQ?: InputMaybe<Scalars['u8']['input']>;
  speed?: InputMaybe<Scalars['usize']['input']>;
  speedEQ?: InputMaybe<Scalars['usize']['input']>;
  speedGT?: InputMaybe<Scalars['usize']['input']>;
  speedGTE?: InputMaybe<Scalars['usize']['input']>;
  speedLT?: InputMaybe<Scalars['usize']['input']>;
  speedLTE?: InputMaybe<Scalars['usize']['input']>;
  speedNEQ?: InputMaybe<Scalars['usize']['input']>;
  start_time?: InputMaybe<Scalars['u64']['input']>;
  start_timeEQ?: InputMaybe<Scalars['u64']['input']>;
  start_timeGT?: InputMaybe<Scalars['u64']['input']>;
  start_timeGTE?: InputMaybe<Scalars['u64']['input']>;
  start_timeLT?: InputMaybe<Scalars['u64']['input']>;
  start_timeLTE?: InputMaybe<Scalars['u64']['input']>;
  start_timeNEQ?: InputMaybe<Scalars['u64']['input']>;
};

export type IncomingMissionLen = {
  __typename?: 'IncomingMissionLen';
  entity?: Maybe<World__Entity>;
  lenght?: Maybe<Scalars['usize']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type IncomingMissionLenConnection = {
  __typename?: 'IncomingMissionLenConnection';
  edges?: Maybe<Array<Maybe<IncomingMissionLenEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type IncomingMissionLenEdge = {
  __typename?: 'IncomingMissionLenEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<IncomingMissionLen>;
};

export type IncomingMissionLenOrder = {
  direction: OrderDirection;
  field: IncomingMissionLenOrderField;
};

export enum IncomingMissionLenOrderField {
  Lenght = 'LENGHT',
  PlanetId = 'PLANET_ID',
}

export type IncomingMissionLenWhereInput = {
  lenght?: InputMaybe<Scalars['usize']['input']>;
  lenghtEQ?: InputMaybe<Scalars['usize']['input']>;
  lenghtGT?: InputMaybe<Scalars['usize']['input']>;
  lenghtGTE?: InputMaybe<Scalars['usize']['input']>;
  lenghtLT?: InputMaybe<Scalars['usize']['input']>;
  lenghtLTE?: InputMaybe<Scalars['usize']['input']>;
  lenghtNEQ?: InputMaybe<Scalars['usize']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type IncomingMissions = {
  __typename?: 'IncomingMissions';
  entity?: Maybe<World__Entity>;
  mission?: Maybe<IncomingMissions_IncomingMission>;
  mission_id?: Maybe<Scalars['usize']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type IncomingMissionsConnection = {
  __typename?: 'IncomingMissionsConnection';
  edges?: Maybe<Array<Maybe<IncomingMissionsEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type IncomingMissionsEdge = {
  __typename?: 'IncomingMissionsEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<IncomingMissions>;
};

export type IncomingMissionsOrder = {
  direction: OrderDirection;
  field: IncomingMissionsOrderField;
};

export enum IncomingMissionsOrderField {
  Mission = 'MISSION',
  MissionId = 'MISSION_ID',
  PlanetId = 'PLANET_ID',
}

export type IncomingMissionsWhereInput = {
  mission_id?: InputMaybe<Scalars['usize']['input']>;
  mission_idEQ?: InputMaybe<Scalars['usize']['input']>;
  mission_idGT?: InputMaybe<Scalars['usize']['input']>;
  mission_idGTE?: InputMaybe<Scalars['usize']['input']>;
  mission_idLT?: InputMaybe<Scalars['usize']['input']>;
  mission_idLTE?: InputMaybe<Scalars['usize']['input']>;
  mission_idNEQ?: InputMaybe<Scalars['usize']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type IncomingMissions_IncomingMission = {
  __typename?: 'IncomingMissions_IncomingMission';
  destination?: Maybe<Scalars['u32']['output']>;
  id_at_origin?: Maybe<Scalars['usize']['output']>;
  number_of_ships?: Maybe<Scalars['u32']['output']>;
  origin?: Maybe<Scalars['u32']['output']>;
  time_arrival?: Maybe<Scalars['u64']['output']>;
};

export type LastActive = {
  __typename?: 'LastActive';
  entity?: Maybe<World__Entity>;
  planet_id?: Maybe<Scalars['u32']['output']>;
  time?: Maybe<Scalars['u64']['output']>;
};

export type LastActiveConnection = {
  __typename?: 'LastActiveConnection';
  edges?: Maybe<Array<Maybe<LastActiveEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type LastActiveEdge = {
  __typename?: 'LastActiveEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<LastActive>;
};

export type LastActiveOrder = {
  direction: OrderDirection;
  field: LastActiveOrderField;
};

export enum LastActiveOrderField {
  PlanetId = 'PLANET_ID',
  Time = 'TIME',
}

export type LastActiveWhereInput = {
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
  time?: InputMaybe<Scalars['u64']['input']>;
  timeEQ?: InputMaybe<Scalars['u64']['input']>;
  timeGT?: InputMaybe<Scalars['u64']['input']>;
  timeGTE?: InputMaybe<Scalars['u64']['input']>;
  timeLT?: InputMaybe<Scalars['u64']['input']>;
  timeLTE?: InputMaybe<Scalars['u64']['input']>;
  timeNEQ?: InputMaybe<Scalars['u64']['input']>;
};

export type ModelUnion =
  | ActiveMission
  | ActiveMissionLen
  | ColonyCompounds
  | ColonyCount
  | ColonyDefences
  | ColonyOwner
  | ColonyPosition
  | ColonyResource
  | ColonyResourceTimer
  | ColonyShips
  | GameOwnerPlanet
  | GamePlanet
  | GamePlanetCount
  | GamePlanetOwner
  | GameSetup
  | IncomingMissionLen
  | IncomingMissions
  | LastActive
  | PlanetColoniesCount
  | PlanetCompounds
  | PlanetDebrisField
  | PlanetDefences
  | PlanetPosition
  | PlanetResource
  | PlanetResourceTimer
  | PlanetResourcesSpent
  | PlanetShips
  | PlanetTechs
  | PositionToPlanet;

export enum OrderDirection {
  Asc = 'ASC',
  Desc = 'DESC',
}

export type PlanetColoniesCount = {
  __typename?: 'PlanetColoniesCount';
  count?: Maybe<Scalars['u8']['output']>;
  entity?: Maybe<World__Entity>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type PlanetColoniesCountConnection = {
  __typename?: 'PlanetColoniesCountConnection';
  edges?: Maybe<Array<Maybe<PlanetColoniesCountEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PlanetColoniesCountEdge = {
  __typename?: 'PlanetColoniesCountEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PlanetColoniesCount>;
};

export type PlanetColoniesCountOrder = {
  direction: OrderDirection;
  field: PlanetColoniesCountOrderField;
};

export enum PlanetColoniesCountOrderField {
  Count = 'COUNT',
  PlanetId = 'PLANET_ID',
}

export type PlanetColoniesCountWhereInput = {
  count?: InputMaybe<Scalars['u8']['input']>;
  countEQ?: InputMaybe<Scalars['u8']['input']>;
  countGT?: InputMaybe<Scalars['u8']['input']>;
  countGTE?: InputMaybe<Scalars['u8']['input']>;
  countLT?: InputMaybe<Scalars['u8']['input']>;
  countLTE?: InputMaybe<Scalars['u8']['input']>;
  countNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type PlanetCompounds = {
  __typename?: 'PlanetCompounds';
  entity?: Maybe<World__Entity>;
  level?: Maybe<Scalars['u8']['output']>;
  name?: Maybe<Scalars['u8']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type PlanetCompoundsConnection = {
  __typename?: 'PlanetCompoundsConnection';
  edges?: Maybe<Array<Maybe<PlanetCompoundsEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PlanetCompoundsEdge = {
  __typename?: 'PlanetCompoundsEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PlanetCompounds>;
};

export type PlanetCompoundsOrder = {
  direction: OrderDirection;
  field: PlanetCompoundsOrderField;
};

export enum PlanetCompoundsOrderField {
  Level = 'LEVEL',
  Name = 'NAME',
  PlanetId = 'PLANET_ID',
}

export type PlanetCompoundsWhereInput = {
  level?: InputMaybe<Scalars['u8']['input']>;
  levelEQ?: InputMaybe<Scalars['u8']['input']>;
  levelGT?: InputMaybe<Scalars['u8']['input']>;
  levelGTE?: InputMaybe<Scalars['u8']['input']>;
  levelLT?: InputMaybe<Scalars['u8']['input']>;
  levelLTE?: InputMaybe<Scalars['u8']['input']>;
  levelNEQ?: InputMaybe<Scalars['u8']['input']>;
  name?: InputMaybe<Scalars['u8']['input']>;
  nameEQ?: InputMaybe<Scalars['u8']['input']>;
  nameGT?: InputMaybe<Scalars['u8']['input']>;
  nameGTE?: InputMaybe<Scalars['u8']['input']>;
  nameLT?: InputMaybe<Scalars['u8']['input']>;
  nameLTE?: InputMaybe<Scalars['u8']['input']>;
  nameNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type PlanetDebrisField = {
  __typename?: 'PlanetDebrisField';
  debris?: Maybe<PlanetDebrisField_Debris>;
  entity?: Maybe<World__Entity>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type PlanetDebrisFieldConnection = {
  __typename?: 'PlanetDebrisFieldConnection';
  edges?: Maybe<Array<Maybe<PlanetDebrisFieldEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PlanetDebrisFieldEdge = {
  __typename?: 'PlanetDebrisFieldEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PlanetDebrisField>;
};

export type PlanetDebrisFieldOrder = {
  direction: OrderDirection;
  field: PlanetDebrisFieldOrderField;
};

export enum PlanetDebrisFieldOrderField {
  Debris = 'DEBRIS',
  PlanetId = 'PLANET_ID',
}

export type PlanetDebrisFieldWhereInput = {
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type PlanetDebrisField_Debris = {
  __typename?: 'PlanetDebrisField_Debris';
  quartz?: Maybe<Scalars['u128']['output']>;
  steel?: Maybe<Scalars['u128']['output']>;
};

export type PlanetDefences = {
  __typename?: 'PlanetDefences';
  count?: Maybe<Scalars['u32']['output']>;
  entity?: Maybe<World__Entity>;
  name?: Maybe<Scalars['u8']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type PlanetDefencesConnection = {
  __typename?: 'PlanetDefencesConnection';
  edges?: Maybe<Array<Maybe<PlanetDefencesEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PlanetDefencesEdge = {
  __typename?: 'PlanetDefencesEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PlanetDefences>;
};

export type PlanetDefencesOrder = {
  direction: OrderDirection;
  field: PlanetDefencesOrderField;
};

export enum PlanetDefencesOrderField {
  Count = 'COUNT',
  Name = 'NAME',
  PlanetId = 'PLANET_ID',
}

export type PlanetDefencesWhereInput = {
  count?: InputMaybe<Scalars['u32']['input']>;
  countEQ?: InputMaybe<Scalars['u32']['input']>;
  countGT?: InputMaybe<Scalars['u32']['input']>;
  countGTE?: InputMaybe<Scalars['u32']['input']>;
  countLT?: InputMaybe<Scalars['u32']['input']>;
  countLTE?: InputMaybe<Scalars['u32']['input']>;
  countNEQ?: InputMaybe<Scalars['u32']['input']>;
  name?: InputMaybe<Scalars['u8']['input']>;
  nameEQ?: InputMaybe<Scalars['u8']['input']>;
  nameGT?: InputMaybe<Scalars['u8']['input']>;
  nameGTE?: InputMaybe<Scalars['u8']['input']>;
  nameLT?: InputMaybe<Scalars['u8']['input']>;
  nameLTE?: InputMaybe<Scalars['u8']['input']>;
  nameNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type PlanetPosition = {
  __typename?: 'PlanetPosition';
  entity?: Maybe<World__Entity>;
  planet_id?: Maybe<Scalars['u32']['output']>;
  position?: Maybe<PlanetPosition_Position>;
};

export type PlanetPositionConnection = {
  __typename?: 'PlanetPositionConnection';
  edges?: Maybe<Array<Maybe<PlanetPositionEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PlanetPositionEdge = {
  __typename?: 'PlanetPositionEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PlanetPosition>;
};

export type PlanetPositionOrder = {
  direction: OrderDirection;
  field: PlanetPositionOrderField;
};

export enum PlanetPositionOrderField {
  PlanetId = 'PLANET_ID',
  Position = 'POSITION',
}

export type PlanetPositionWhereInput = {
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type PlanetPosition_Position = {
  __typename?: 'PlanetPosition_Position';
  orbit?: Maybe<Scalars['u8']['output']>;
  system?: Maybe<Scalars['u16']['output']>;
};

export type PlanetResource = {
  __typename?: 'PlanetResource';
  amount?: Maybe<Scalars['u128']['output']>;
  entity?: Maybe<World__Entity>;
  name?: Maybe<Scalars['u8']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type PlanetResourceConnection = {
  __typename?: 'PlanetResourceConnection';
  edges?: Maybe<Array<Maybe<PlanetResourceEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PlanetResourceEdge = {
  __typename?: 'PlanetResourceEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PlanetResource>;
};

export type PlanetResourceOrder = {
  direction: OrderDirection;
  field: PlanetResourceOrderField;
};

export enum PlanetResourceOrderField {
  Amount = 'AMOUNT',
  Name = 'NAME',
  PlanetId = 'PLANET_ID',
}

export type PlanetResourceTimer = {
  __typename?: 'PlanetResourceTimer';
  entity?: Maybe<World__Entity>;
  last_collection?: Maybe<Scalars['u64']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type PlanetResourceTimerConnection = {
  __typename?: 'PlanetResourceTimerConnection';
  edges?: Maybe<Array<Maybe<PlanetResourceTimerEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PlanetResourceTimerEdge = {
  __typename?: 'PlanetResourceTimerEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PlanetResourceTimer>;
};

export type PlanetResourceTimerOrder = {
  direction: OrderDirection;
  field: PlanetResourceTimerOrderField;
};

export enum PlanetResourceTimerOrderField {
  LastCollection = 'LAST_COLLECTION',
  PlanetId = 'PLANET_ID',
}

export type PlanetResourceTimerWhereInput = {
  last_collection?: InputMaybe<Scalars['u64']['input']>;
  last_collectionEQ?: InputMaybe<Scalars['u64']['input']>;
  last_collectionGT?: InputMaybe<Scalars['u64']['input']>;
  last_collectionGTE?: InputMaybe<Scalars['u64']['input']>;
  last_collectionLT?: InputMaybe<Scalars['u64']['input']>;
  last_collectionLTE?: InputMaybe<Scalars['u64']['input']>;
  last_collectionNEQ?: InputMaybe<Scalars['u64']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type PlanetResourceWhereInput = {
  amount?: InputMaybe<Scalars['u128']['input']>;
  amountEQ?: InputMaybe<Scalars['u128']['input']>;
  amountGT?: InputMaybe<Scalars['u128']['input']>;
  amountGTE?: InputMaybe<Scalars['u128']['input']>;
  amountLT?: InputMaybe<Scalars['u128']['input']>;
  amountLTE?: InputMaybe<Scalars['u128']['input']>;
  amountNEQ?: InputMaybe<Scalars['u128']['input']>;
  name?: InputMaybe<Scalars['u8']['input']>;
  nameEQ?: InputMaybe<Scalars['u8']['input']>;
  nameGT?: InputMaybe<Scalars['u8']['input']>;
  nameGTE?: InputMaybe<Scalars['u8']['input']>;
  nameLT?: InputMaybe<Scalars['u8']['input']>;
  nameLTE?: InputMaybe<Scalars['u8']['input']>;
  nameNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type PlanetResourcesSpent = {
  __typename?: 'PlanetResourcesSpent';
  entity?: Maybe<World__Entity>;
  planet_id?: Maybe<Scalars['u32']['output']>;
  spent?: Maybe<Scalars['u128']['output']>;
};

export type PlanetResourcesSpentConnection = {
  __typename?: 'PlanetResourcesSpentConnection';
  edges?: Maybe<Array<Maybe<PlanetResourcesSpentEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PlanetResourcesSpentEdge = {
  __typename?: 'PlanetResourcesSpentEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PlanetResourcesSpent>;
};

export type PlanetResourcesSpentOrder = {
  direction: OrderDirection;
  field: PlanetResourcesSpentOrderField;
};

export enum PlanetResourcesSpentOrderField {
  PlanetId = 'PLANET_ID',
  Spent = 'SPENT',
}

export type PlanetResourcesSpentWhereInput = {
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
  spent?: InputMaybe<Scalars['u128']['input']>;
  spentEQ?: InputMaybe<Scalars['u128']['input']>;
  spentGT?: InputMaybe<Scalars['u128']['input']>;
  spentGTE?: InputMaybe<Scalars['u128']['input']>;
  spentLT?: InputMaybe<Scalars['u128']['input']>;
  spentLTE?: InputMaybe<Scalars['u128']['input']>;
  spentNEQ?: InputMaybe<Scalars['u128']['input']>;
};

export type PlanetShips = {
  __typename?: 'PlanetShips';
  count?: Maybe<Scalars['u32']['output']>;
  entity?: Maybe<World__Entity>;
  name?: Maybe<Scalars['u8']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type PlanetShipsConnection = {
  __typename?: 'PlanetShipsConnection';
  edges?: Maybe<Array<Maybe<PlanetShipsEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PlanetShipsEdge = {
  __typename?: 'PlanetShipsEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PlanetShips>;
};

export type PlanetShipsOrder = {
  direction: OrderDirection;
  field: PlanetShipsOrderField;
};

export enum PlanetShipsOrderField {
  Count = 'COUNT',
  Name = 'NAME',
  PlanetId = 'PLANET_ID',
}

export type PlanetShipsWhereInput = {
  count?: InputMaybe<Scalars['u32']['input']>;
  countEQ?: InputMaybe<Scalars['u32']['input']>;
  countGT?: InputMaybe<Scalars['u32']['input']>;
  countGTE?: InputMaybe<Scalars['u32']['input']>;
  countLT?: InputMaybe<Scalars['u32']['input']>;
  countLTE?: InputMaybe<Scalars['u32']['input']>;
  countNEQ?: InputMaybe<Scalars['u32']['input']>;
  name?: InputMaybe<Scalars['u8']['input']>;
  nameEQ?: InputMaybe<Scalars['u8']['input']>;
  nameGT?: InputMaybe<Scalars['u8']['input']>;
  nameGTE?: InputMaybe<Scalars['u8']['input']>;
  nameLT?: InputMaybe<Scalars['u8']['input']>;
  nameLTE?: InputMaybe<Scalars['u8']['input']>;
  nameNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type PlanetTechs = {
  __typename?: 'PlanetTechs';
  entity?: Maybe<World__Entity>;
  level?: Maybe<Scalars['u8']['output']>;
  name?: Maybe<Scalars['u8']['output']>;
  planet_id?: Maybe<Scalars['u32']['output']>;
};

export type PlanetTechsConnection = {
  __typename?: 'PlanetTechsConnection';
  edges?: Maybe<Array<Maybe<PlanetTechsEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PlanetTechsEdge = {
  __typename?: 'PlanetTechsEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PlanetTechs>;
};

export type PlanetTechsOrder = {
  direction: OrderDirection;
  field: PlanetTechsOrderField;
};

export enum PlanetTechsOrderField {
  Level = 'LEVEL',
  Name = 'NAME',
  PlanetId = 'PLANET_ID',
}

export type PlanetTechsWhereInput = {
  level?: InputMaybe<Scalars['u8']['input']>;
  levelEQ?: InputMaybe<Scalars['u8']['input']>;
  levelGT?: InputMaybe<Scalars['u8']['input']>;
  levelGTE?: InputMaybe<Scalars['u8']['input']>;
  levelLT?: InputMaybe<Scalars['u8']['input']>;
  levelLTE?: InputMaybe<Scalars['u8']['input']>;
  levelNEQ?: InputMaybe<Scalars['u8']['input']>;
  name?: InputMaybe<Scalars['u8']['input']>;
  nameEQ?: InputMaybe<Scalars['u8']['input']>;
  nameGT?: InputMaybe<Scalars['u8']['input']>;
  nameGTE?: InputMaybe<Scalars['u8']['input']>;
  nameLT?: InputMaybe<Scalars['u8']['input']>;
  nameLTE?: InputMaybe<Scalars['u8']['input']>;
  nameNEQ?: InputMaybe<Scalars['u8']['input']>;
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type PositionToPlanet = {
  __typename?: 'PositionToPlanet';
  entity?: Maybe<World__Entity>;
  planet_id?: Maybe<Scalars['u32']['output']>;
  position?: Maybe<PositionToPlanet_Position>;
};

export type PositionToPlanetConnection = {
  __typename?: 'PositionToPlanetConnection';
  edges?: Maybe<Array<Maybe<PositionToPlanetEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type PositionToPlanetEdge = {
  __typename?: 'PositionToPlanetEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<PositionToPlanet>;
};

export type PositionToPlanetOrder = {
  direction: OrderDirection;
  field: PositionToPlanetOrderField;
};

export enum PositionToPlanetOrderField {
  PlanetId = 'PLANET_ID',
  Position = 'POSITION',
}

export type PositionToPlanetWhereInput = {
  planet_id?: InputMaybe<Scalars['u32']['input']>;
  planet_idEQ?: InputMaybe<Scalars['u32']['input']>;
  planet_idGT?: InputMaybe<Scalars['u32']['input']>;
  planet_idGTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idLT?: InputMaybe<Scalars['u32']['input']>;
  planet_idLTE?: InputMaybe<Scalars['u32']['input']>;
  planet_idNEQ?: InputMaybe<Scalars['u32']['input']>;
};

export type PositionToPlanet_Position = {
  __typename?: 'PositionToPlanet_Position';
  orbit?: Maybe<Scalars['u8']['output']>;
  system?: Maybe<Scalars['u16']['output']>;
};

export type World__Content = {
  __typename?: 'World__Content';
  coverUri?: Maybe<Scalars['String']['output']>;
  description?: Maybe<Scalars['String']['output']>;
  iconUri?: Maybe<Scalars['String']['output']>;
  name?: Maybe<Scalars['String']['output']>;
  socials?: Maybe<Array<Maybe<World__Social>>>;
  website?: Maybe<Scalars['String']['output']>;
};

export type World__Entity = {
  __typename?: 'World__Entity';
  createdAt?: Maybe<Scalars['DateTime']['output']>;
  eventId?: Maybe<Scalars['String']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  keys?: Maybe<Array<Maybe<Scalars['String']['output']>>>;
  models?: Maybe<Array<Maybe<ModelUnion>>>;
  updatedAt?: Maybe<Scalars['DateTime']['output']>;
};

export type World__EntityConnection = {
  __typename?: 'World__EntityConnection';
  edges?: Maybe<Array<Maybe<World__EntityEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type World__EntityEdge = {
  __typename?: 'World__EntityEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Entity>;
};

export type World__Event = {
  __typename?: 'World__Event';
  createdAt?: Maybe<Scalars['DateTime']['output']>;
  data?: Maybe<Array<Maybe<Scalars['String']['output']>>>;
  id?: Maybe<Scalars['ID']['output']>;
  keys?: Maybe<Array<Maybe<Scalars['String']['output']>>>;
  transactionHash?: Maybe<Scalars['String']['output']>;
};

export type World__EventConnection = {
  __typename?: 'World__EventConnection';
  edges?: Maybe<Array<Maybe<World__EventEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type World__EventEdge = {
  __typename?: 'World__EventEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Event>;
};

export type World__Metadata = {
  __typename?: 'World__Metadata';
  content?: Maybe<World__Content>;
  coverImg?: Maybe<Scalars['String']['output']>;
  createdAt?: Maybe<Scalars['DateTime']['output']>;
  iconImg?: Maybe<Scalars['String']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  updatedAt?: Maybe<Scalars['DateTime']['output']>;
  uri?: Maybe<Scalars['String']['output']>;
  worldAddress: Scalars['String']['output'];
};

export type World__MetadataConnection = {
  __typename?: 'World__MetadataConnection';
  edges?: Maybe<Array<Maybe<World__MetadataEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type World__MetadataEdge = {
  __typename?: 'World__MetadataEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Metadata>;
};

export type World__Model = {
  __typename?: 'World__Model';
  classHash?: Maybe<Scalars['felt252']['output']>;
  createdAt?: Maybe<Scalars['DateTime']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  name?: Maybe<Scalars['String']['output']>;
  transactionHash?: Maybe<Scalars['felt252']['output']>;
};

export type World__ModelConnection = {
  __typename?: 'World__ModelConnection';
  edges?: Maybe<Array<Maybe<World__ModelEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type World__ModelEdge = {
  __typename?: 'World__ModelEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Model>;
};

export type World__ModelOrder = {
  direction: OrderDirection;
  field: World__ModelOrderField;
};

export enum World__ModelOrderField {
  ClassHash = 'CLASS_HASH',
  Name = 'NAME',
}

export type World__PageInfo = {
  __typename?: 'World__PageInfo';
  endCursor?: Maybe<Scalars['Cursor']['output']>;
  hasNextPage?: Maybe<Scalars['Boolean']['output']>;
  hasPreviousPage?: Maybe<Scalars['Boolean']['output']>;
  startCursor?: Maybe<Scalars['Cursor']['output']>;
};

export type World__Query = {
  __typename?: 'World__Query';
  activeMissionLenModels?: Maybe<ActiveMissionLenConnection>;
  activeMissionModels?: Maybe<ActiveMissionConnection>;
  colonyCompoundsModels?: Maybe<ColonyCompoundsConnection>;
  colonyCountModels?: Maybe<ColonyCountConnection>;
  colonyDefencesModels?: Maybe<ColonyDefencesConnection>;
  colonyOwnerModels?: Maybe<ColonyOwnerConnection>;
  colonyPositionModels?: Maybe<ColonyPositionConnection>;
  colonyResourceModels?: Maybe<ColonyResourceConnection>;
  colonyResourceTimerModels?: Maybe<ColonyResourceTimerConnection>;
  colonyShipsModels?: Maybe<ColonyShipsConnection>;
  entities?: Maybe<World__EntityConnection>;
  entity: World__Entity;
  events?: Maybe<World__EventConnection>;
  gameOwnerPlanetModels?: Maybe<GameOwnerPlanetConnection>;
  gamePlanetCountModels?: Maybe<GamePlanetCountConnection>;
  gamePlanetModels?: Maybe<GamePlanetConnection>;
  gamePlanetOwnerModels?: Maybe<GamePlanetOwnerConnection>;
  gameSetupModels?: Maybe<GameSetupConnection>;
  incomingMissionLenModels?: Maybe<IncomingMissionLenConnection>;
  incomingMissionsModels?: Maybe<IncomingMissionsConnection>;
  lastActiveModels?: Maybe<LastActiveConnection>;
  metadatas?: Maybe<World__MetadataConnection>;
  model: World__Model;
  models?: Maybe<World__ModelConnection>;
  planetColoniesCountModels?: Maybe<PlanetColoniesCountConnection>;
  planetCompoundsModels?: Maybe<PlanetCompoundsConnection>;
  planetDebrisFieldModels?: Maybe<PlanetDebrisFieldConnection>;
  planetDefencesModels?: Maybe<PlanetDefencesConnection>;
  planetPositionModels?: Maybe<PlanetPositionConnection>;
  planetResourceModels?: Maybe<PlanetResourceConnection>;
  planetResourceTimerModels?: Maybe<PlanetResourceTimerConnection>;
  planetResourcesSpentModels?: Maybe<PlanetResourcesSpentConnection>;
  planetShipsModels?: Maybe<PlanetShipsConnection>;
  planetTechsModels?: Maybe<PlanetTechsConnection>;
  positionToPlanetModels?: Maybe<PositionToPlanetConnection>;
  transaction: World__Transaction;
  transactions?: Maybe<World__TransactionConnection>;
};

export type World__QueryActiveMissionLenModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ActiveMissionLenOrder>;
  where?: InputMaybe<ActiveMissionLenWhereInput>;
};

export type World__QueryActiveMissionModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ActiveMissionOrder>;
  where?: InputMaybe<ActiveMissionWhereInput>;
};

export type World__QueryColonyCompoundsModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ColonyCompoundsOrder>;
  where?: InputMaybe<ColonyCompoundsWhereInput>;
};

export type World__QueryColonyCountModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ColonyCountOrder>;
  where?: InputMaybe<ColonyCountWhereInput>;
};

export type World__QueryColonyDefencesModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ColonyDefencesOrder>;
  where?: InputMaybe<ColonyDefencesWhereInput>;
};

export type World__QueryColonyOwnerModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ColonyOwnerOrder>;
  where?: InputMaybe<ColonyOwnerWhereInput>;
};

export type World__QueryColonyPositionModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ColonyPositionOrder>;
  where?: InputMaybe<ColonyPositionWhereInput>;
};

export type World__QueryColonyResourceModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ColonyResourceOrder>;
  where?: InputMaybe<ColonyResourceWhereInput>;
};

export type World__QueryColonyResourceTimerModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ColonyResourceTimerOrder>;
  where?: InputMaybe<ColonyResourceTimerWhereInput>;
};

export type World__QueryColonyShipsModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<ColonyShipsOrder>;
  where?: InputMaybe<ColonyShipsWhereInput>;
};

export type World__QueryEntitiesArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  keys?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type World__QueryEntityArgs = {
  id: Scalars['ID']['input'];
};

export type World__QueryEventsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  keys?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type World__QueryGameOwnerPlanetModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<GameOwnerPlanetOrder>;
  where?: InputMaybe<GameOwnerPlanetWhereInput>;
};

export type World__QueryGamePlanetCountModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<GamePlanetCountOrder>;
  where?: InputMaybe<GamePlanetCountWhereInput>;
};

export type World__QueryGamePlanetModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<GamePlanetOrder>;
  where?: InputMaybe<GamePlanetWhereInput>;
};

export type World__QueryGamePlanetOwnerModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<GamePlanetOwnerOrder>;
  where?: InputMaybe<GamePlanetOwnerWhereInput>;
};

export type World__QueryGameSetupModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<GameSetupOrder>;
  where?: InputMaybe<GameSetupWhereInput>;
};

export type World__QueryIncomingMissionLenModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<IncomingMissionLenOrder>;
  where?: InputMaybe<IncomingMissionLenWhereInput>;
};

export type World__QueryIncomingMissionsModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<IncomingMissionsOrder>;
  where?: InputMaybe<IncomingMissionsWhereInput>;
};

export type World__QueryLastActiveModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<LastActiveOrder>;
  where?: InputMaybe<LastActiveWhereInput>;
};

export type World__QueryMetadatasArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type World__QueryModelArgs = {
  id: Scalars['ID']['input'];
};

export type World__QueryModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<World__ModelOrder>;
};

export type World__QueryPlanetColoniesCountModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PlanetColoniesCountOrder>;
  where?: InputMaybe<PlanetColoniesCountWhereInput>;
};

export type World__QueryPlanetCompoundsModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PlanetCompoundsOrder>;
  where?: InputMaybe<PlanetCompoundsWhereInput>;
};

export type World__QueryPlanetDebrisFieldModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PlanetDebrisFieldOrder>;
  where?: InputMaybe<PlanetDebrisFieldWhereInput>;
};

export type World__QueryPlanetDefencesModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PlanetDefencesOrder>;
  where?: InputMaybe<PlanetDefencesWhereInput>;
};

export type World__QueryPlanetPositionModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PlanetPositionOrder>;
  where?: InputMaybe<PlanetPositionWhereInput>;
};

export type World__QueryPlanetResourceModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PlanetResourceOrder>;
  where?: InputMaybe<PlanetResourceWhereInput>;
};

export type World__QueryPlanetResourceTimerModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PlanetResourceTimerOrder>;
  where?: InputMaybe<PlanetResourceTimerWhereInput>;
};

export type World__QueryPlanetResourcesSpentModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PlanetResourcesSpentOrder>;
  where?: InputMaybe<PlanetResourcesSpentWhereInput>;
};

export type World__QueryPlanetShipsModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PlanetShipsOrder>;
  where?: InputMaybe<PlanetShipsWhereInput>;
};

export type World__QueryPlanetTechsModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PlanetTechsOrder>;
  where?: InputMaybe<PlanetTechsWhereInput>;
};

export type World__QueryPositionToPlanetModelsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
  order?: InputMaybe<PositionToPlanetOrder>;
  where?: InputMaybe<PositionToPlanetWhereInput>;
};

export type World__QueryTransactionArgs = {
  transactionHash: Scalars['ID']['input'];
};

export type World__QueryTransactionsArgs = {
  after?: InputMaybe<Scalars['Cursor']['input']>;
  before?: InputMaybe<Scalars['Cursor']['input']>;
  first?: InputMaybe<Scalars['Int']['input']>;
  last?: InputMaybe<Scalars['Int']['input']>;
  limit?: InputMaybe<Scalars['Int']['input']>;
  offset?: InputMaybe<Scalars['Int']['input']>;
};

export type World__Social = {
  __typename?: 'World__Social';
  name?: Maybe<Scalars['String']['output']>;
  url?: Maybe<Scalars['String']['output']>;
};

export type World__Subscription = {
  __typename?: 'World__Subscription';
  entityUpdated: World__Entity;
  eventEmitted: World__Event;
  modelRegistered: World__Model;
};

export type World__SubscriptionEntityUpdatedArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
};

export type World__SubscriptionEventEmittedArgs = {
  keys?: InputMaybe<Array<InputMaybe<Scalars['String']['input']>>>;
};

export type World__SubscriptionModelRegisteredArgs = {
  id?: InputMaybe<Scalars['ID']['input']>;
};

export type World__Transaction = {
  __typename?: 'World__Transaction';
  calldata?: Maybe<Array<Maybe<Scalars['felt252']['output']>>>;
  createdAt?: Maybe<Scalars['DateTime']['output']>;
  id?: Maybe<Scalars['ID']['output']>;
  maxFee?: Maybe<Scalars['felt252']['output']>;
  nonce?: Maybe<Scalars['felt252']['output']>;
  senderAddress?: Maybe<Scalars['felt252']['output']>;
  signature?: Maybe<Array<Maybe<Scalars['felt252']['output']>>>;
  transactionHash?: Maybe<Scalars['felt252']['output']>;
};

export type World__TransactionConnection = {
  __typename?: 'World__TransactionConnection';
  edges?: Maybe<Array<Maybe<World__TransactionEdge>>>;
  pageInfo: World__PageInfo;
  totalCount: Scalars['Int']['output'];
};

export type World__TransactionEdge = {
  __typename?: 'World__TransactionEdge';
  cursor?: Maybe<Scalars['Cursor']['output']>;
  node?: Maybe<World__Transaction>;
};

export type GetPlanetResourceQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
  name: Scalars['u8']['input'];
}>;

export type GetPlanetResourceQuery = {
  __typename?: 'World__Query';
  planetResourceModels?: {
    __typename?: 'PlanetResourceConnection';
    edges?: Array<{
      __typename?: 'PlanetResourceEdge';
      node?: {
        __typename?: 'PlanetResource';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | { __typename: 'PlanetPosition' }
            | {
                __typename: 'PlanetResource';
                planet_id?: unknown | null;
                name?: unknown | null;
                amount?: unknown | null;
              }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetPlanetCompoundQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
  name: Scalars['u8']['input'];
}>;

export type GetPlanetCompoundQuery = {
  __typename?: 'World__Query';
  planetCompoundsModels?: {
    __typename?: 'PlanetCompoundsConnection';
    edges?: Array<{
      __typename?: 'PlanetCompoundsEdge';
      node?: {
        __typename?: 'PlanetCompounds';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | {
                __typename: 'PlanetCompounds';
                planet_id?: unknown | null;
                name?: unknown | null;
                level?: unknown | null;
              }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | { __typename: 'PlanetPosition' }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetPlanetTechQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
  name: Scalars['u8']['input'];
}>;

export type GetPlanetTechQuery = {
  __typename?: 'World__Query';
  planetTechsModels?: {
    __typename?: 'PlanetTechsConnection';
    edges?: Array<{
      __typename?: 'PlanetTechsEdge';
      node?: {
        __typename?: 'PlanetTechs';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | { __typename: 'PlanetPosition' }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | {
                __typename: 'PlanetTechs';
                planet_id?: unknown | null;
                name?: unknown | null;
                level?: unknown | null;
              }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetPlanetPositionQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
}>;

export type GetPlanetPositionQuery = {
  __typename?: 'World__Query';
  planetPositionModels?: {
    __typename?: 'PlanetPositionConnection';
    edges?: Array<{
      __typename?: 'PlanetPositionEdge';
      node?: {
        __typename?: 'PlanetPosition';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | {
                __typename: 'PlanetPosition';
                planet_id?: unknown | null;
                position?: {
                  __typename?: 'PlanetPosition_Position';
                  system?: unknown | null;
                  orbit?: unknown | null;
                } | null;
              }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetPlanetShipQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
  name: Scalars['u8']['input'];
}>;

export type GetPlanetShipQuery = {
  __typename?: 'World__Query';
  planetShipsModels?: {
    __typename?: 'PlanetShipsConnection';
    edges?: Array<{
      __typename?: 'PlanetShipsEdge';
      node?: {
        __typename?: 'PlanetShips';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | { __typename: 'PlanetPosition' }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | {
                __typename: 'PlanetShips';
                planet_id?: unknown | null;
                name?: unknown | null;
                count?: unknown | null;
              }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetPlanetDefenceQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
  name: Scalars['u8']['input'];
}>;

export type GetPlanetDefenceQuery = {
  __typename?: 'World__Query';
  planetDefencesModels?: {
    __typename?: 'PlanetDefencesConnection';
    edges?: Array<{
      __typename?: 'PlanetDefencesEdge';
      node?: {
        __typename?: 'PlanetDefences';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | {
                __typename: 'PlanetDefences';
                planet_id?: unknown | null;
                name?: unknown | null;
                count?: unknown | null;
              }
            | { __typename: 'PlanetPosition' }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetColonyResourceQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
  colony_id: Scalars['u8']['input'];
  name: Scalars['u8']['input'];
}>;

export type GetColonyResourceQuery = {
  __typename?: 'World__Query';
  colonyResourceModels?: {
    __typename?: 'ColonyResourceConnection';
    edges?: Array<{
      __typename?: 'ColonyResourceEdge';
      node?: {
        __typename?: 'ColonyResource';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | {
                __typename: 'ColonyResource';
                planet_id?: unknown | null;
                colony_id?: unknown | null;
                name?: unknown | null;
                amount?: unknown | null;
              }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | { __typename: 'PlanetPosition' }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetColonyCompoundQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
  colony_id: Scalars['u8']['input'];
  name: Scalars['u8']['input'];
}>;

export type GetColonyCompoundQuery = {
  __typename?: 'World__Query';
  colonyCompoundsModels?: {
    __typename?: 'ColonyCompoundsConnection';
    edges?: Array<{
      __typename?: 'ColonyCompoundsEdge';
      node?: {
        __typename?: 'ColonyCompounds';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | {
                __typename: 'ColonyCompounds';
                planet_id?: unknown | null;
                colony_id?: unknown | null;
                name?: unknown | null;
                level?: unknown | null;
              }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | { __typename: 'PlanetPosition' }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetColonyShipQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
  colony_id: Scalars['u8']['input'];
  name: Scalars['u8']['input'];
}>;

export type GetColonyShipQuery = {
  __typename?: 'World__Query';
  colonyShipsModels?: {
    __typename?: 'ColonyShipsConnection';
    edges?: Array<{
      __typename?: 'ColonyShipsEdge';
      node?: {
        __typename?: 'ColonyShips';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | {
                __typename: 'ColonyShips';
                planet_id?: unknown | null;
                colony_id?: unknown | null;
                name?: unknown | null;
                count?: unknown | null;
              }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | { __typename: 'PlanetPosition' }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetColonyDefenceQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
  colony_id: Scalars['u8']['input'];
  name: Scalars['u8']['input'];
}>;

export type GetColonyDefenceQuery = {
  __typename?: 'World__Query';
  colonyDefencesModels?: {
    __typename?: 'ColonyDefencesConnection';
    edges?: Array<{
      __typename?: 'ColonyDefencesEdge';
      node?: {
        __typename?: 'ColonyDefences';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | {
                __typename: 'ColonyDefences';
                planet_id?: unknown | null;
                colony_id?: unknown | null;
                name?: unknown | null;
                count?: unknown | null;
              }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | { __typename: 'PlanetPosition' }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetPlanetColoniesCountQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
}>;

export type GetPlanetColoniesCountQuery = {
  __typename?: 'World__Query';
  planetColoniesCountModels?: {
    __typename?: 'PlanetColoniesCountConnection';
    edges?: Array<{
      __typename?: 'PlanetColoniesCountEdge';
      node?: {
        __typename?: 'PlanetColoniesCount';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | { __typename: 'ColonyPosition' }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | {
                __typename: 'PlanetColoniesCount';
                planet_id?: unknown | null;
                count?: unknown | null;
              }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | { __typename: 'PlanetPosition' }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetColonyPositionQueryVariables = Exact<{
  planet_id: Scalars['u32']['input'];
  colony_id: Scalars['u8']['input'];
}>;

export type GetColonyPositionQuery = {
  __typename?: 'World__Query';
  colonyPositionModels?: {
    __typename?: 'ColonyPositionConnection';
    edges?: Array<{
      __typename?: 'ColonyPositionEdge';
      node?: {
        __typename?: 'ColonyPosition';
        entity?: {
          __typename?: 'World__Entity';
          keys?: Array<string | null> | null;
          models?: Array<
            | { __typename: 'ActiveMission' }
            | { __typename: 'ActiveMissionLen' }
            | { __typename: 'ColonyCompounds' }
            | { __typename: 'ColonyCount' }
            | { __typename: 'ColonyDefences' }
            | { __typename: 'ColonyOwner' }
            | {
                __typename: 'ColonyPosition';
                planet_id?: unknown | null;
                colony_id?: unknown | null;
                position?: {
                  __typename?: 'ColonyPosition_Position';
                  system?: unknown | null;
                  orbit?: unknown | null;
                } | null;
              }
            | { __typename: 'ColonyResource' }
            | { __typename: 'ColonyResourceTimer' }
            | { __typename: 'ColonyShips' }
            | { __typename: 'GameOwnerPlanet' }
            | { __typename: 'GamePlanet' }
            | { __typename: 'GamePlanetCount' }
            | { __typename: 'GamePlanetOwner' }
            | { __typename: 'GameSetup' }
            | { __typename: 'IncomingMissionLen' }
            | { __typename: 'IncomingMissions' }
            | { __typename: 'LastActive' }
            | { __typename: 'PlanetColoniesCount' }
            | { __typename: 'PlanetCompounds' }
            | { __typename: 'PlanetDebrisField' }
            | { __typename: 'PlanetDefences' }
            | { __typename: 'PlanetPosition' }
            | { __typename: 'PlanetResource' }
            | { __typename: 'PlanetResourceTimer' }
            | { __typename: 'PlanetResourcesSpent' }
            | { __typename: 'PlanetShips' }
            | { __typename: 'PlanetTechs' }
            | { __typename: 'PositionToPlanet' }
            | null
          > | null;
        } | null;
      } | null;
    } | null> | null;
  } | null;
};

export type GetGeneratedPlanetsQueryVariables = Exact<{ [key: string]: never }>;

export type GetGeneratedPlanetsQuery = {
  __typename?: 'World__Query';
  events?: {
    __typename?: 'World__EventConnection';
    edges?: Array<{
      __typename?: 'World__EventEdge';
      node?: {
        __typename?: 'World__Event';
        data?: Array<string | null> | null;
      } | null;
    } | null> | null;
  } | null;
};

export const GetPlanetResourceDocument = gql`
  query getPlanetResource($planet_id: u32!, $name: u8!) {
    planetResourceModels(where: { planet_id: $planet_id, name: $name }) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on PlanetResource {
                planet_id
                name
                amount
              }
            }
          }
        }
      }
    }
  }
`;
export const GetPlanetCompoundDocument = gql`
  query getPlanetCompound($planet_id: u32!, $name: u8!) {
    planetCompoundsModels(where: { planet_id: $planet_id, name: $name }) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on PlanetCompounds {
                planet_id
                name
                level
              }
            }
          }
        }
      }
    }
  }
`;
export const GetPlanetTechDocument = gql`
  query getPlanetTech($planet_id: u32!, $name: u8!) {
    planetTechsModels(where: { planet_id: $planet_id, name: $name }) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on PlanetTechs {
                planet_id
                name
                level
              }
            }
          }
        }
      }
    }
  }
`;
export const GetPlanetPositionDocument = gql`
  query getPlanetPosition($planet_id: u32!) {
    planetPositionModels(where: { planet_id: $planet_id }) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on PlanetPosition {
                planet_id
                position {
                  system
                  orbit
                }
              }
            }
          }
        }
      }
    }
  }
`;
export const GetPlanetShipDocument = gql`
  query getPlanetShip($planet_id: u32!, $name: u8!) {
    planetShipsModels(where: { planet_id: $planet_id, name: $name }) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on PlanetShips {
                planet_id
                name
                count
              }
            }
          }
        }
      }
    }
  }
`;
export const GetPlanetDefenceDocument = gql`
  query getPlanetDefence($planet_id: u32!, $name: u8!) {
    planetDefencesModels(where: { planet_id: $planet_id, name: $name }) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on PlanetDefences {
                planet_id
                name
                count
              }
            }
          }
        }
      }
    }
  }
`;
export const GetColonyResourceDocument = gql`
  query getColonyResource($planet_id: u32!, $colony_id: u8!, $name: u8!) {
    colonyResourceModels(
      where: { planet_id: $planet_id, colony_id: $colony_id, name: $name }
    ) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on ColonyResource {
                planet_id
                colony_id
                name
                amount
              }
            }
          }
        }
      }
    }
  }
`;
export const GetColonyCompoundDocument = gql`
  query getColonyCompound($planet_id: u32!, $colony_id: u8!, $name: u8!) {
    colonyCompoundsModels(
      where: { planet_id: $planet_id, colony_id: $colony_id, name: $name }
    ) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on ColonyCompounds {
                planet_id
                colony_id
                name
                level
              }
            }
          }
        }
      }
    }
  }
`;
export const GetColonyShipDocument = gql`
  query getColonyShip($planet_id: u32!, $colony_id: u8!, $name: u8!) {
    colonyShipsModels(
      where: { planet_id: $planet_id, colony_id: $colony_id, name: $name }
    ) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on ColonyShips {
                planet_id
                colony_id
                name
                count
              }
            }
          }
        }
      }
    }
  }
`;
export const GetColonyDefenceDocument = gql`
  query getColonyDefence($planet_id: u32!, $colony_id: u8!, $name: u8!) {
    colonyDefencesModels(
      where: { planet_id: $planet_id, colony_id: $colony_id, name: $name }
    ) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on ColonyDefences {
                planet_id
                colony_id
                name
                count
              }
            }
          }
        }
      }
    }
  }
`;
export const GetPlanetColoniesCountDocument = gql`
  query getPlanetColoniesCount($planet_id: u32!) {
    planetColoniesCountModels(where: { planet_id: $planet_id }) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on PlanetColoniesCount {
                planet_id
                count
              }
            }
          }
        }
      }
    }
  }
`;
export const GetColonyPositionDocument = gql`
  query getColonyPosition($planet_id: u32!, $colony_id: u8!) {
    colonyPositionModels(
      where: { planet_id: $planet_id, colony_id: $colony_id }
    ) {
      edges {
        node {
          entity {
            keys
            models {
              __typename
              ... on ColonyPosition {
                planet_id
                colony_id
                position {
                  system
                  orbit
                }
              }
            }
          }
        }
      }
    }
  }
`;
export const GetGeneratedPlanetsDocument = gql`
  query getGeneratedPlanets {
    events(
      keys: ["0x166c64e5e6cde79e1bc7d23a31ebe5be13be5d7b1c23c72ec2fbfae5678be1"]
    ) {
      edges {
        node {
          data
        }
      }
    }
  }
`;

export type SdkFunctionWrapper = <T>(
  action: (requestHeaders?: Record<string, string>) => Promise<T>,
  operationName: string,
  operationType?: string,
  variables?: unknown
) => Promise<T>;

const defaultWrapper: SdkFunctionWrapper = (
  action
  // _operationName,
  // _operationType,
  // _variables
) => action();
const GetPlanetResourceDocumentString = print(GetPlanetResourceDocument);
const GetPlanetCompoundDocumentString = print(GetPlanetCompoundDocument);
const GetPlanetTechDocumentString = print(GetPlanetTechDocument);
const GetPlanetPositionDocumentString = print(GetPlanetPositionDocument);
const GetPlanetShipDocumentString = print(GetPlanetShipDocument);
const GetPlanetDefenceDocumentString = print(GetPlanetDefenceDocument);
const GetColonyResourceDocumentString = print(GetColonyResourceDocument);
const GetColonyCompoundDocumentString = print(GetColonyCompoundDocument);
const GetColonyShipDocumentString = print(GetColonyShipDocument);
const GetColonyDefenceDocumentString = print(GetColonyDefenceDocument);
const GetPlanetColoniesCountDocumentString = print(
  GetPlanetColoniesCountDocument
);
const GetColonyPositionDocumentString = print(GetColonyPositionDocument);
const GetGeneratedPlanetsDocumentString = print(GetGeneratedPlanetsDocument);
export function getSdk(
  client: GraphQLClient,
  withWrapper: SdkFunctionWrapper = defaultWrapper
) {
  return {
    getPlanetResource(
      variables: GetPlanetResourceQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetPlanetResourceQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetPlanetResourceQuery>(
            GetPlanetResourceDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getPlanetResource',
        'query',
        variables
      );
    },
    getPlanetCompound(
      variables: GetPlanetCompoundQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetPlanetCompoundQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetPlanetCompoundQuery>(
            GetPlanetCompoundDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getPlanetCompound',
        'query',
        variables
      );
    },
    getPlanetTech(
      variables: GetPlanetTechQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetPlanetTechQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetPlanetTechQuery>(
            GetPlanetTechDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getPlanetTech',
        'query',
        variables
      );
    },
    getPlanetPosition(
      variables: GetPlanetPositionQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetPlanetPositionQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetPlanetPositionQuery>(
            GetPlanetPositionDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getPlanetPosition',
        'query',
        variables
      );
    },
    getPlanetShip(
      variables: GetPlanetShipQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetPlanetShipQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetPlanetShipQuery>(
            GetPlanetShipDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getPlanetShip',
        'query',
        variables
      );
    },
    getPlanetDefence(
      variables: GetPlanetDefenceQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetPlanetDefenceQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetPlanetDefenceQuery>(
            GetPlanetDefenceDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getPlanetDefence',
        'query',
        variables
      );
    },
    getColonyResource(
      variables: GetColonyResourceQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetColonyResourceQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetColonyResourceQuery>(
            GetColonyResourceDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getColonyResource',
        'query',
        variables
      );
    },
    getColonyCompound(
      variables: GetColonyCompoundQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetColonyCompoundQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetColonyCompoundQuery>(
            GetColonyCompoundDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getColonyCompound',
        'query',
        variables
      );
    },
    getColonyShip(
      variables: GetColonyShipQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetColonyShipQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetColonyShipQuery>(
            GetColonyShipDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getColonyShip',
        'query',
        variables
      );
    },
    getColonyDefence(
      variables: GetColonyDefenceQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetColonyDefenceQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetColonyDefenceQuery>(
            GetColonyDefenceDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getColonyDefence',
        'query',
        variables
      );
    },
    getPlanetColoniesCount(
      variables: GetPlanetColoniesCountQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetPlanetColoniesCountQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetPlanetColoniesCountQuery>(
            GetPlanetColoniesCountDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getPlanetColoniesCount',
        'query',
        variables
      );
    },
    getColonyPosition(
      variables: GetColonyPositionQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetColonyPositionQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetColonyPositionQuery>(
            GetColonyPositionDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getColonyPosition',
        'query',
        variables
      );
    },
    getGeneratedPlanets(
      variables?: GetGeneratedPlanetsQueryVariables,
      requestHeaders?: GraphQLClientRequestHeaders
    ): Promise<{
      data: GetGeneratedPlanetsQuery;
      errors?: GraphQLError[];
      extensions?: unknown;
      headers: Headers;
      status: number;
    }> {
      return withWrapper(
        (wrappedRequestHeaders) =>
          client.rawRequest<GetGeneratedPlanetsQuery>(
            GetGeneratedPlanetsDocumentString,
            variables,
            { ...requestHeaders, ...wrappedRequestHeaders }
          ),
        'getGeneratedPlanets',
        'query',
        variables
      );
    },
  };
}
export type Sdk = ReturnType<typeof getSdk>;
