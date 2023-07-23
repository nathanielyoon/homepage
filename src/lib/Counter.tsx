import { createSignal, type Component } from "solid-js";

export default (): Component => {
  const [count, setCount] = createSignal(0);
  return <button onclick={() => setCount(current => current + 1)} class="btn btn-primary">{count()}</button>;
}

