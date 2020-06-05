using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StarTrigger : MonoBehaviour
{
    [SerializeField]
    private GameObject _stars;     

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "EventTrigger")
        {
            _stars.SetActive(true);
        }

        if (other.tag == "Player")
        {
            Destroy(this.gameObject, 0f);
        }
    }
}
