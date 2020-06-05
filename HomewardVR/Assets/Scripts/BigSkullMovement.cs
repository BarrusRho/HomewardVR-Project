using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BigSkullMovement : MonoBehaviour
{
    [SerializeField]
    private float _movementSpeed;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.position += Time.deltaTime * transform.forward * _movementSpeed;  //Skull moves in the Z axis at a speed defined by movementSpeed.
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "BigSkullDestroyTrigger")
        {
            Destroy(this.gameObject, 0f);
        }
    }
}
