using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TriggerMovement : MonoBehaviour
{
    [SerializeField]
    private float _movementSpeed;  

    // Update is called once per frame
    void Update()
    {
        transform.position += Time.deltaTime * transform.forward * _movementSpeed;  //Trigger moves in the Z axis at a speed defined by movementSpeed.
    }

}
