import asyncio

async def big_task_1():
    print("Start big task 1")
    # Simulate a time-consuming task
    await asyncio.sleep(5)
    print("End big task 1")

async def big_task_2():
    print("Start big task 2")
    # Simulate another time-consuming task
    await asyncio.sleep(3)
    print("End big task 2")

async def main():
    # Create tasks to run asynchronously
    task1 = asyncio.create_task(big_task_1())
    task2 = asyncio.create_task(big_task_2())
    i = 0
    while i < 100000:
        if i %1000 == 0:
            print('hmmm')
        asyncio.gather(task1, task2)
        i+=1
    # Run other non-blocking tasks concurrently if needed

    # Wait for all tasks to complete
    #await asyncio.gather(task1, task2)

# Run the main function
asyncio.run(main())
