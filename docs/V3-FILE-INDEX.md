# BERT V3 File Index

This index lists files introduced or changed for the BERT V3 Community Layer.

## V3 Smart Contracts

1. `contracts/BERT/V3/community/CommunityFactory.sol`
2. `contracts/BERT/V3/community/CommunityHub.sol`
3. `contracts/BERT/V3/community/CommunityTreasury.sol`
4. `contracts/BERT/V3/community/CommunityTreasuryDeployer.sol`
5. `contracts/BERT/V3/interfaces/ICommunityFactory.sol`
6. `contracts/BERT/V3/interfaces/ICommunityHub.sol`
7. `contracts/BERT/V3/interfaces/ICommunityTreasury.sol`
8. `contracts/BERT/V3/interfaces/ICommunityTreasuryDeployer.sol`
9. `contracts/BERT/V3/interfaces/IGlobalBertReserve.sol`
10. `contracts/BERT/V3/utils/CommunityErrors.sol`
11. `contracts/BERT/V3/utils/CommunityTypes.sol`

## V2 Integration Changes

1. `contracts/BERT/DAO/FundingPoolUpgradeable.sol` - authenticates active CommunityTreasuries and receives V3 protocol reserve inflows.
2. `contracts/BERT/interfaces/IFundingPool.sol` - exposes V3 reserve integration methods and events.
3. `contracts/BERT/interfaces/ICommunityFactoryRegistry.sol` - V2-facing interface implemented by V3 Factory.

## V3 Mocks

1. `contracts/Mocks/MockCommunityFactoryRegistry.sol`
2. `contracts/Mocks/MockCommunityHub.sol`
3. `contracts/Mocks/MockCommunityReserveTreasury.sol`
4. `contracts/Mocks/MockGlobalBertReserve.sol`

## V3 Test Suites

1. `test/V3/CommunityFactory.fully.ts`
2. `test/V3/CommunityHub.fully.ts`
3. `test/V3/CommunityTreasury.fully.ts`
4. `test/V3/CommunityReserveIntegration.fully.ts`
5. `test/FundingPoolUpgradeable.fully.ts` - includes V3 reserve authentication coverage.
6. `test/helpers.ts` - includes Transparent proxy support used by V3 Factory tests.

## Deployment And Operations

1. `scripts/deploy/deploy-v3.ts`
2. `scripts/deploy/configure-v3-funding-pool.ts`
3. `scripts/deploy/verify-v3.ts`
4. `scripts/deploy/docs_deploy/V3_DEPLOY.md`
5. `scripts/deploy/upgrade-proxy.ts` - existing generic proxy upgrader used when an existing FundingPool must become V3-aware.

## V3 Documentation

1. `contracts/BERT/V3/README.md`
2. `contracts/BERT/V3/docs_contracts/README.md`
3. `contracts/BERT/V3/docs_contracts/CommunityFactory.md`
4. `contracts/BERT/V3/docs_contracts/CommunityHub.md`
5. `contracts/BERT/V3/docs_contracts/CommunityTreasury.md`
6. `contracts/BERT/V3/docs_contracts/CommunityTreasuryDeployer.md`
7. `contracts/BERT/V3/docs_contracts/Interfaces.md`
8. `contracts/BERT/V3/docs_contracts/CommunityTypes.md`
9. `contracts/BERT/V3/docs_contracts/CommunityErrors.md`
