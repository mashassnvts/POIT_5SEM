using UnityEngine;

public class Rotation_Quaternion : MonoBehaviour
{
    private Quaternion initialRotation;
    private float angle;

    void Start()
    {
        initialRotation = transform.rotation;
    }

    void Update()
    {
        angle += 60 * Time.deltaTime;

        Quaternion rotationX = Quaternion.AngleAxis(angle, Vector3.right);
        Quaternion rotationZ = Quaternion.AngleAxis(angle, Vector3.forward);

        transform.rotation = initialRotation * rotationX * rotationZ;//��������� ������ ��������

        Vector3 arbitraryAxis = new Vector3(1, 1, 0).normalized;//������������ ��� ��������
        Quaternion arbitraryRotation = Quaternion.AngleAxis(angle, arbitraryAxis);//��������� �������� ����� ������������ ��� �� ������� ����

        transform.rotation = initialRotation * rotationX * rotationZ * arbitraryRotation;
    }
}