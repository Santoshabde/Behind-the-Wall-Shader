using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public class ZombieBehavior : MonoBehaviour
{
    [SerializeField] Camera camera;
    [SerializeField] private NavMeshAgent agent;
    [SerializeField] List<Transform> idealRoamPoints;
    [SerializeField] GameObject sphere;

    private int destinationIndex = 0;
    private void Update()
    {
        if (!ReachedDestination(idealRoamPoints[destinationIndex].position))
            agent.SetDestination(idealRoamPoints[destinationIndex].position);

        if(sphere != null)
        {
            Ray ray = new Ray(transform.position, camera.transform.position - transform.position);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit, 20))
            {
                if (hit.transform.gameObject.tag == "Wall")
                {
                    sphere.SetActive(true);
                }
                else
                {
                    sphere.SetActive(false);
                }
            }
            else
                sphere.SetActive(false);
        }

        Debug.DrawRay(transform.position, camera.transform.position - transform.position, Color.red);

    }

    private bool ReachedDestination(Vector3 destinationPoint)
    {
        if (Vector3.Distance(transform.position, destinationPoint) < 0.2f)
        {
            destinationIndex++;
            if (destinationIndex >= idealRoamPoints.Count - 1)
                destinationIndex = 0;
            return true;
        }

        return false;
    }
}
