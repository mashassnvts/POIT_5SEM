using System;
using System.Threading.Tasks;

class Program
{
    const int ObservationTime = 10;
    static int TaskCount = 24; 
    static int[,] Matrix = new int[TaskCount, ObservationTime]; 

    static void Main(string[] args)
    {
        Task[] t = new Task[TaskCount]; 
        int[] numbers = new int[TaskCount]; 
        for (int i = 0; i < TaskCount; i++)
            numbers[i] = i; 

        Console.WriteLine("A student ... is creating tasks...");

        for (int i = 0; i < TaskCount; i++)
        {
            int index = i; 
            if (i == 0)
            {
                t[i] = new Task(() => Work(index));
                t[i].Start();
            }
            else
            {
                t[i] = t[i - 1].ContinueWith(delegate { Work(index); });
            }
        }

        Console.WriteLine("A student ... is waiting for tasks to finish...");
        Task.WaitAll(t); 

        Console.WriteLine("Statistics:");
        for (int s = 0; s < ObservationTime; s++)
        {
            Console.Write("{0,3}: ", s);
            for (int th = 0; th < TaskCount; th++)
                Console.Write(" {0,5}", Matrix[th, s]);
            Console.WriteLine();
        }
    }

    static void Work(int id)
    {
        for (int s = 0; s < ObservationTime; s++)
        {
            Matrix[id, s] = id + s; 
            System.Threading.Thread.Sleep(100); 
        }
    }
}
