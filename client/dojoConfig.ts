import { createDojoConfig } from '@dojoengine/core';
import manifest from '../contracts/target/dev/manifest.json';

export const dojoConfig = createDojoConfig({
  manifest,
});
