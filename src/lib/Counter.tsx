import { createSignal } from "solid-js";

export default () => {
  const [count, setCount] = createSignal(0);
  return (
    <div class="flex h-screen w-full items-center justify-center">
      <button
        onclick={() => setCount((current) => current + 1)}
        class="btn btn-primary btn-lg"
      >
        {count()}
      </button>
    </div>
  );
};
