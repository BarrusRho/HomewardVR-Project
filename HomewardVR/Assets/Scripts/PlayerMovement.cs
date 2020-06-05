using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [SerializeField]
    public float _movementSpeed;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        transform.position += Time.deltaTime * transform.forward * _movementSpeed;  //Player moves in the Z axis at a speed defined by movementSpeed.
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag != "Player")
        {
            Destroy(other.gameObject, 0f);
        }
    }
}
