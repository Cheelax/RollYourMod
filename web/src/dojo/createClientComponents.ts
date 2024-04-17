import { overridableComponent } from "@dojoengine/recs";
import { ContractComponents } from "./generated/contractComponents";

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
  contractComponents,
}: {
  contractComponents: ContractComponents;
}) {
  return {
    ...contractComponents,
    //add components like above
    CommitHash: overridableComponent(contractComponents.CommitHash),
    Hustler: overridableComponent(contractComponents.Hustler),
    HustlerState: overridableComponent(contractComponents.HustlerState),
    Move: overridableComponent(contractComponents.Move),
    TwoPlayerGame: overridableComponent(contractComponents.TwoPlayerGame),
  };
}
