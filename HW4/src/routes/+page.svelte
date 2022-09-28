<script>
    import { each } from "svelte/internal";

    let todos = [];
    let task = "";
    let error = "";

    //  function to add todo 
    const addTodo = () => {
        let todo = {
            task: task,
            isComplete: false,
            createdAt: new Date(),
        };
        if (task !== "") {
            todos = [todo, ...todos];
            error = "";
        } else {
            error = "Error: task is empty";
        }
        task = "";
    };

    // function to mark todo as complete 
    const markToDoAsComplete = (index) => {
        todos[index].isComplete = !todos[index].isComplete;
    };

    // function to delete todo
    const deleteTodo = (index) => {
        let deleteItem = todos[index];
        todos = todos.filter((item) => item != deleteItem);
    };

    // add todos with enter keystroke
    const keyIsPressed = (event) => {
        if(event.key === "Enter") {
            addTodo()
        }
    }

    $: console.table(todos);
</script>

<input type="text" placeholder="Add a task" bind:value={task} />
<button on:click={addTodo}>Add</button>

<ol>
    {#each todos as item, index}
    <li class:complete={item.isComplete}>
        <span>
            <!-- display task -->
            {item.task}
        </span>
        <span>
            <!-- button to mark todo item as complete -->
            <button on:click={() => markToDoAsComplete(index)}>✓</button>
            <!-- button to delete todo item -->
            <button on:click={() => deleteTodo(index)}>✘</button>
        </span>
    </li>
    <!-- else, display "no todos" -->
    {:else}
    <p>no todos</p>
    {/each}
    <p class="error">{error}</p>
</ol>

<!--  svelte tag for a function that depends on the window object -->
<svelte:window on:keydown={keyIsPressed} />

<style>
    .complete{
        text-decoration: line-through;
    }
    .error {
        color: red;
    }
</style>