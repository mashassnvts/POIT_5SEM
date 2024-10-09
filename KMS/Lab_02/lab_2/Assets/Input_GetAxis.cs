using UnityEngine;

public class Input_GetAxis : MonoBehaviour
{
    private float horizontalMove;
    private float verticalMove;
    private float mouseX;
    private float mouseY;

    private float verticalRotationLimit = 90f;

    public float rotationSpeed = 3f;

    void Update()
    {
        horizontalMove = Input.GetAxis("Horizontal");
        verticalMove = Input.GetAxis("Vertical");
        mouseX = Input.GetAxis("Mouse X");
        mouseY = Input.GetAxis("Mouse Y");

        transform.Translate(horizontalMove, 0, verticalMove);

        transform.Rotate(Vector3.up, mouseX * rotationSpeed);

        float desiredVerticalRotation = transform.eulerAngles.x - mouseY * rotationSpeed;//вычисление вертикального угла вращения
        desiredVerticalRotation = Mathf.Clamp(desiredVerticalRotation, 0f, verticalRotationLimit);//ограничение
        transform.eulerAngles = new Vector3(desiredVerticalRotation, transform.eulerAngles.y, 0f);
    }
}
