using System;
using System.Threading.Tasks;

class Program
{
    const int TaskCount = 10;  
    const int ObservationTime = 10;  
    static int[,] Matrix = new int[TaskCount, ObservationTime]; 

    static void Main(string[] args)
    {
        Task[] tasks = new Task[TaskCount];
        int[] numbers = new int[TaskCount];

        for (int i = 0; i < TaskCount; i++)
            numbers[i] = i;

        Console.WriteLine("A student ... is creating tasks...");

        for (int i = 0; i < TaskCount; i++)
        {
            int taskIndex = i;  
            tasks[i] = Task.Run(() => Work(taskIndex));
        }

        Console.WriteLine("A student ... is waiting for tasks to finish...");
        Task.WaitAll(tasks);  

        Console.WriteLine("Results of task execution:");
        for (int s = 0; s < ObservationTime; s++)
        {
            Console.Write("{0,3}: ", s);
            for (int th = 0; th < TaskCount; th++)
                Console.Write(" {0,5}", Matrix[th, s]);
            Console.WriteLine();
        }
    }

    static void Work(int index)
    {
        Random rand = new Random();
        for (int s = 0; s < ObservationTime; s++)
        {
            Matrix[index, s] = rand.Next(0, 10); 
            Task.Delay(rand.Next(100, 500)).Wait(); 
        }
    }
}
